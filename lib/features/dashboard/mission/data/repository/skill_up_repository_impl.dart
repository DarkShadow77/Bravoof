import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/skill_up_mission_model.dart';
import 'skill_up_repository.dart';

class SkillUpRepositoryImpl extends SkillUpRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<SkillUpMission>>> fetchSkillUpMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<SkillUpMission>>(
      functionName: 'fetch-skill-up-missions',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Skill Up Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => SkillUpMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, void>> completeSkillUpStep({
    required int skillUpMissionId,
    required int stepId,
    required String? image,
    required String? text,
    required bool isVideo,
  }) async {
    final token = supabase.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'step_id': stepId,
      'skill_up_mission_id': skillUpMissionId,
      'evidence_image': !isVideo && image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidenceVideo': isVideo && image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidence_text': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-skill-up-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete SkillUp Step Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete SkillUp Step Mission",
      );
    }
  }

  Future<Either<String, void>> unlockSkillUpStep({
    required int stepId,
    required UnlockSource source,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'unlock-skill-up-step',
      body: {"stepId": stepId, "source": source.name.toUpperCase()},
      fallbackErrorMessage: 'Failed to Unlock Skill Up Mission',
      onSuccess: (data) => "Successfully Unlocked Skill Up",
    );
  }
}
