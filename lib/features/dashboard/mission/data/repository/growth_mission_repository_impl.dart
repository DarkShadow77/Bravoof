import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../session/session_manager.dart';
import '../../../../dashboard/earn/data/models/mission_res.dart';
import '../model/mission_status_enum.dart';
import 'growth_mission_repository.dart';

class GrowthMissionRepositoryImpl extends GrowthMissionRepository {
  final supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  /// Fetch featured mission
  Future<Either<String, List<Mission>>> fetchGrowthMission() async {
    try {
      final userId = sessionManager.userIdVal;

      final missionsRes = await supabase.from('mission').select();
      final completedRes = await supabase
          .from('mission_completed')
          .select()
          .eq('user_id', userId);

      // Create a map of mission_id -> completed
      final completedMap = {
        for (var item in completedRes) item['mission_id']: item['completed'],
      };

      MissionResponse missionResponse = MissionResponse.fromJson({
        "mission": missionsRes,
      });

      // Mark completed missions for this user
      missionResponse.mission = missionResponse.mission!.map((mission) {
        mission.completed = completedMap[mission.id] ?? false;
        return mission;
      }).toList();

      missionResponse.mission!.sort((a, b) => a.id!.compareTo(b.id!));

      return Right(missionResponse.mission ?? []);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Join / Update mission
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
  }

  /// Check if user already joined
  Future<MissionStatus> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    final res = await supabase
        .from('featured_mission_completed')
        .select('status')
        .eq('featured_mission_id', missionId)
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) {
      return MissionStatus.notJoined;
    }

    return statusFromDb(res['status'] as String);
  }
}
