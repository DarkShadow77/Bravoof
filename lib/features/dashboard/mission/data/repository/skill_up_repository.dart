import 'package:dartz/dartz.dart';

import '../model/skill_up_mission_model.dart';

abstract class SkillUpRepository {
  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission();

  Future<Either<String, void>> completeSkillUpStep({
    required int skillUpMissionId,
    required int stepId,
    String? evidenceImage,
    String? evidenceText,
  });

  Future<Either<String, void>> unlockSkillUpStep({
    required int stepId,
    required UnlockSource source,
  });
}
