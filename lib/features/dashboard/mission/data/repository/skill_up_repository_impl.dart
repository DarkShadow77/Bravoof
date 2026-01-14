import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/skill_up_mission_model.dart';
import 'skill_up_repository.dart';

class SkillUpRepositoryImpl extends SkillUpRepository {
  final supabase = Supabase.instance.client;

  /// Fetch skillup mission
  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission({
    required String userId,
  }) async {
    try {
      final res = await supabase
          .from('skill_up_missions')
          .select('''
      id,
      title,
      image,
      is_hot,
      color,
      created_at,
      skill_up_steps (
        id,
        step_order,
        title,
        subject,
        content_one,
        content_two,
        min_points,
        max_points,
        locked,
        skill_up_user_progress!left (
          status,
          submission,
          evidence_image
        ),
        skill_up_step_unlocks!left (
          unlock_source,
          expires_at
        )
      )
    ''')
          .eq('skill_up_steps.skill_up_user_progress.user_id', userId)
          .eq('skill_up_steps.skill_up_step_unlocks.user_id', userId);

      if (res.isEmpty) {
        return Left('No SkillUp Mission found');
      }
      return Right(res.map((e) => SkillUpMission.fromJson(e)).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> completeSkillUpStep({
    required int skillUpMissionId,
    required int stepId,
    required String userId,
    String? submission,
    String? evidenceImage,
  }) async {
    try {
      // 🔒 Validate step belongs to mission
      final step = await supabase
          .from('skill_up_steps')
          .select('skill_up_mission_id')
          .eq('id', stepId)
          .single();

      if (step['skill_up_mission_id'] != skillUpMissionId) {
        return Left('Step does not belong to this Skill Up mission');
      }

      // ✅ Upsert progress
      await supabase.from('skill_up_user_progress').upsert({
        'skill_up_step_id': stepId,
        'user_id': userId,
        'status': "PENDING",
        'submission': submission,
        'evidence_image': evidenceImage,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,skill_up_step_id');

      return const Right(null);
    } catch (e) {
      Logger().t("Complete Skill Up Missions Error ${e.toString()}");
      log("Complete Skill Up Missions Error ${e.toString()}");
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> unlockSkillUpStep({
    required int stepId,
    required UnlockSource source,
    required String userId,
  }) async {
    try {
      await supabase.rpc(
        'unlock_skill_up_step',
        params: {
          'p_user_id': userId,
          'p_step_id': stepId,
          'p_source': source.name.toUpperCase(),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
