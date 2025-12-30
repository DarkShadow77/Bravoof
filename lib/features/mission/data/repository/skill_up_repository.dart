import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/skill_up_mission_model.dart';

abstract class SkillUpRepository {
  final supabase = Supabase.instance.client;

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
}
