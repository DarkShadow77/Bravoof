import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/community_mission_model.dart';
import '../model/mission_status_enum.dart';
import 'community_mission_repository.dart';

class CommunityMissionRepositoryImpl extends CommunityMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, CommunityMission>> fetchCommunityMission() async {
    return ApiService.instance!.invokeEdgeFunction<CommunityMission>(
      functionName: 'fetch-community-mission',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Community Mission',
      onSuccess: (data) => CommunityMission.fromJson(data["data"]),
    );
  }

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String? imageUrl,
    required String text,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'userId': userId,
      'image': imageUrl != null
          ? await MultipartFile.fromFile(
              imageUrl,
              filename: imageUrl.split('/').last,
            )
          : null,
      'evidenceText': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-community-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete Community Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete Community Mission",
      );
    }
  }

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionStatus>(
      functionName: 'has-joined-community',
      body: {"missionId": missionId, "userId": userId},
      fallbackErrorMessage: 'Failed to Fetch Community Status',
      onSuccess: (data) => statusFromDb(data["data"]["status"] as String),
    );
  }
}
