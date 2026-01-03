import 'package:dartz/dartz.dart';

import '../model/skill_up_mission_model.dart';

abstract class SkillUpRepository {
  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission({
    required String userId,
  });

  Future<Either<String, void>> completeSkillUpStep({
    required int skillUpMissionId,
    required int stepId,
    required String userId,
    String? submission,
    String? evidenceImage,
  });

  Future<Either<String, void>> unlockSkillUpStep({
    required int stepId,
    required UnlockSource source,
    required String userId,
  });
}
