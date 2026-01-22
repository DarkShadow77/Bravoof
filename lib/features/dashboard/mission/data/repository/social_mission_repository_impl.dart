import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../model/mission_status_enum.dart';
import '../model/social_mission_model.dart';
import 'social_mission_repository.dart';

class SocialMissionRepositoryImpl extends SocialMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<SocialMission>>> fetchSocialMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<SocialMission>>(
      functionName: 'fetch-social-missions',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Social Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => SocialMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String text,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'complete-social-mission',
      body: {'missionId': missionId, 'userId': userId, 'text': text},
      fallbackErrorMessage: 'Failed to Complete Social Mission',
      onSuccess: (data) => "Completed Social Mission",
    );
  }

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionStatus>(
      functionName: 'has-joined-social',
      body: {"missionId": missionId, "userId": userId},
      fallbackErrorMessage: 'Failed to Fetch Social Status',
      onSuccess: (data) => statusFromDb(data["data"]["status"] as String),
    );
  }
}
