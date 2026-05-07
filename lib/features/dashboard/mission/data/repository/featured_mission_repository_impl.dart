import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/featured_mission_model.dart';
import '../model/mission_status_enum.dart';
import 'featured_mission_repository.dart';

class FeaturedMissionRepositoryImpl extends FeaturedMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<FeaturedMission>>> fetchFeaturedMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<FeaturedMission>>(
      functionName: 'fetch-featured-missions',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Featured Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => FeaturedMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String? image,
    required String? text,
    required bool isVideo,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'image': !isVideo && image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidenceVideo': isVideo && image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidenceText': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-featured-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete Featured Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete Featured Mission",
      );
    }
  }

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionStatus>(
      functionName: 'has-joined-featured',
      body: {"missionId": missionId, "userId": userId},
      fallbackErrorMessage: 'Failed to Fetch Featured Status',
      onSuccess: (data) => statusFromDb(data["data"]["status"] as String),
    );
  }
}
