import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/mission_status_enum.dart';
import '../model/new_social_mission_model.dart';
import 'new_social_mission_repository.dart';

class NewSocialMissionRepositoryImpl extends NewSocialMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<NewSocialMission>>> fetchNewSocialMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<NewSocialMission>>(
      functionName: 'fetch-new-social-missions',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch NewSocial Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => NewSocialMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String imageUrl,
    required String text,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'userId': userId,
      'evidenceImage': await MultipartFile.fromFile(
        imageUrl,
        filename: imageUrl.split('/').last,
      ),
      'evidenceText': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-new-social-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete NewSocial Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete NewSocial Mission",
      );
    }
  }

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionStatus>(
      functionName: 'has-joined-new-social',
      body: {"missionId": missionId, "userId": userId},
      fallbackErrorMessage: 'Failed to Fetch NewSocial Status',
      onSuccess: (data) => statusFromDb(data["data"]["status"] as String),
    );
  }
}
