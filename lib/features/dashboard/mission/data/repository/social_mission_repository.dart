import 'package:dartz/dartz.dart';

import '../model/mission_status_enum.dart';
import '../model/social_mission_model.dart';

abstract class SocialMissionRepository {
  Future<Either<String, List<SocialMission>>> fetchSocialMission();

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String? imageUrl,
    required String text,
  });

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  });
}
