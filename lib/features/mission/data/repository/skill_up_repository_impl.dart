import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/mission_status_enum.dart';
import '../model/skill_up_mission_model.dart';
import 'skill_up_repository.dart';

class SkillUpRepositoryImpl extends SkillUpRepository {
  final supabase = Supabase.instance.client;

  /// Fetch skillup mission
  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission({
    required String userId,
  }) async {
    try {
      log("Skill Up Missions ");
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
        skill_up_user_progress (
          status,
          submission,
          evidence_image
        )
      )
    ''')
          .eq('skill_up_steps.skill_up_user_progress.user_id', userId);

      Logger().t("Skill Up Missions $res");
      log("Skill Up Missions $res");

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

  /// Join / Update mission
  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String? text,
    required String? imageUrl,
  }) async {
    try {
      // Check if user already joined
      final existing = await supabase
          .from('sponsored_mission_completed')
          .select('id')
          .eq('sponsored_mission_id', missionId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        // First join
        await supabase.from('sponsored_mission_completed').insert({
          'sponsored_mission_id': missionId,
          'user_id': userId,
          // 'answer': text,
          'evidence_image': imageUrl,
          'status': 'PENDING',
        });
      } else {
        // Update existing submission
        await supabase
            .from('sponsored_mission_completed')
            .update({
              // 'answer': text,
              'evidence_image': imageUrl,
              'status': 'PENDING',
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      }
    } catch (e) {
      return Left(e.toString());
    }

    return const Right(null);
  }

  /// Check if user already joined
  Future<MissionStatus> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    final res = await supabase
        .from('sponsored_mission_completed')
        .select('status')
        .eq('sponsored_mission_id', missionId)
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) {
      return MissionStatus.notJoined;
    }

    return statusFromDb(res['status'] as String);
  }
}
