import 'package:dartz/dartz.dart';

import '../model/skill_up_mission_model.dart';

abstract class SkillUpRepository {
  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission();

  Future<Either<String, void>> completeSkillUpStep({
    required int skillUpMissionId,
    required int stepId,
    required String? image,
    required String? text,
    required bool isVideo,
  });

  Future<Either<String, void>> unlockSkillUpStep({
    required int stepId,
    required UnlockSource source,
  });
}
