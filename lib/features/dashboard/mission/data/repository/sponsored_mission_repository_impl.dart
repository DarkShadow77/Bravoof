import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/mission_status_enum.dart';
import '../model/sponsored_mission_model.dart';
import 'sponsored_mission_repository.dart';

class SponsoredMissionRepositoryImpl extends SponsoredMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<SponsoredMission>>> fetchSponsoredMission() async {
    return ApiService.instance!.invokeEdgeFunction<List<SponsoredMission>>(
      functionName: 'fetch-sponsored-missions',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Sponsored Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => SponsoredMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String? image,
    required String? text,
    required bool isVideo,
  }) async {
    final token = supabase.auth.currentSession?.accessToken ?? "";
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
      "functions/v1/complete-sponsored-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete Sponsored Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete Sponsored Mission",
      );
    }
  }

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionStatus>(
      functionName: 'has-joined-sponsored',
      body: {"missionId": missionId, "userId": userId},
      fallbackErrorMessage: 'Failed to Fetch Sponsored Status',
      onSuccess: (data) => statusFromDb(data["data"]["status"] as String),
    );
  }
}
