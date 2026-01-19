import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../../session/session_manager.dart';
import '../../../../dashboard/earn/data/models/mission_res.dart';
import 'growth_mission_repository.dart';

class GrowthMissionRepositoryImpl extends GrowthMissionRepository {
  final supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  /// Fetch featured mission
  Future<Either<String, List<Mission>>> fetchGrowthMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<Mission>>(
      functionName: 'fetch-growth-missions',
      body: {'user_id': supabase.auth.currentUser!.id},
      fallbackErrorMessage: 'Failed to Retrieve Growth Missions',
      onSuccess: (data) {
        final missions = data["data"] as List;
        return missions.map((e) => Mission.fromJson(e)).toList();
      },
    );
  }

  /// Join / Update mission
  Future<Either<String, void>> completeMission({
    required Map<String, dynamic> mission,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'complete-mission',
      body: {'mission': mission},
      fallbackErrorMessage: 'Failed to Complete Growth Mission',
      onSuccess: (data) {},
    );
  }

  /*
  Future<Either<String, void>> completeMission({
    required Map<String, dynamic> mission,
  }) async {
    try {
      final userId = sessionManager.userIdVal;
      final email = sessionManager.userEmailval;

      final int pointsToAdd =
          int.tryParse(mission['points']?.toString() ?? '0') ?? 0;

      final int spinsToAdd =
          int.tryParse(mission['number_of_spins']?.toString() ?? '0') ?? 0;

      // 🔹 Upsert mission completion
      await supabase
          .from('mission_completed')
          .upsert(
            {
              "user_id": userId,
              "mission_id": mission['id'],
              "completed": true,
              "points": pointsToAdd,
              "name": mission['name'],
              "reward_title": mission['reward_title'],
              "number_of_spins": spinsToAdd,
              "updated_at": DateTime.now().toIso8601String(),
              "email": email,
            },
            onConflict: 'user_id, mission_id',
            ignoreDuplicates: false,
          );

      // 🔹 Fetch current totals
      final profileRes = await supabase
          .from('user_profile')
          .select('total_points, spins')
          .eq('user_id', userId)
          .maybeSingle();

      final int currentPoints = profileRes?['total_points'] ?? 0;
      final int currentSpins = profileRes?['spins'] ?? 0;

      final int newPoints = currentPoints + pointsToAdd;
      final int newSpins = currentSpins + spinsToAdd;

      // 🔹 Update BOTH points & spins
      await supabase
          .from('user_profile')
          .update({'total_points': newPoints, 'spins': newSpins})
          .eq('user_id', userId);

      return Right(null);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }*/
}
