import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../dashboard/earn/data/models/mission_res.dart';
import 'growth_mission_repository.dart';

class GrowthMissionRepositoryImpl extends GrowthMissionRepository {
  final supabase = Supabase.instance.client;

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
      functionName: 'complete-growth-mission',
      body: {'mission': mission},
      fallbackErrorMessage: 'Failed to Complete Growth Mission',
      onSuccess: (data) {},
    );
  }
}
