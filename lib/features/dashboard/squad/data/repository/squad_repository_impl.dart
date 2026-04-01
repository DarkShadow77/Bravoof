import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/response/squad_mission_model.dart';
import '../model/response/squad_model.dart';
import 'squad_repository.dart';

class SquadRepositoryImpl extends SquadRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<Squad>>> fetchSquads({String? squadId}) async {
    return ApiService.instance!.invokeEdgeFunction<List<Squad>>(
      functionName: 'fetch-squads',
      body: {"squadId": squadId},
      fallbackErrorMessage: 'Failed to Fetch Squads',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => Squad.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> joinSquad({required String squadId}) async {
    return ApiService.instance!.invokeEdgeFunction(
      functionName: 'join-squad',
      body: {"squadId": squadId},
      fallbackErrorMessage: 'Failed to Join Squad',
      onSuccess: (data) => data["message"] ?? "Successfully joined squad",
    );
  }

  Future<Either<String, String>> leaveSquad({required String squadId}) async {
    return ApiService.instance!.invokeEdgeFunction(
      functionName: 'leave-squad',
      body: {"squadId": squadId},
      fallbackErrorMessage: 'Failed to Leave Squad',
      onSuccess: (data) => data["message"] ?? "Successfully left squad",
    );
  }

  Future<Either<String, List<SquadMission>>> fetchSquadMissions({
    required String squadId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<SquadMission>>(
      functionName: 'fetch-squad-missions',
      body: {"squadId": squadId},
      fallbackErrorMessage: 'Failed to Fetch Squad Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => SquadMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> completeMission({
    required int missionId,
    required String userId,
    required String? image,
    required String text,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'userId': userId,
      'evidenceImage': image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidenceText': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-squad-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete Squad Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(
        response.responseMessage ?? "Mission submitted successfully",
      );
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete Squad Mission",
      );
    }
  }
}
