import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/response/squad_mission_chat_model.dart';
import '../model/response/squad_mission_model.dart';
import '../model/response/squad_model.dart';
import 'squad_repository.dart';

class SquadRepositoryImpl extends SquadRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<Squad>>> fetchSquads({String? squadId}) async {
    return ApiService.instance!.invokeEdgeFunction<List<Squad>>(
      functionName: 'fetch-squads',
      body: {},
      queryParams: {"squadId": squadId},
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

  Future<Either<String, JoinedSquadMission>> joinSquadMission({
    required int missionId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction(
      functionName: 'join-squad-mission',
      body: {"missionId": missionId},
      fallbackErrorMessage: 'Failed to Join Squad Mission',
      onSuccess: (data) => JoinedSquadMission.fromJson(data["data"]),
    );
  }

  Future<Either<String, List<MissionChatMember>>> fetchMissionMembers({
    required int missionId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<MissionChatMember>>(
      functionName: 'fetch-squad-mission-members',
      body: {},
      queryParams: {"missionId": missionId},
      fallbackErrorMessage: 'Failed to Fetch Squad Mission Members',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => MissionChatMember.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> leaveSquadMission({
    required int missionId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction(
      functionName: 'leave-squad-mission',
      body: {"missionId": missionId},
      fallbackErrorMessage: 'Failed to Leave Squad Mission',
      onSuccess: (data) => data["message"] ?? "Successfully Left squad mission",
    );
  }

  Future<Either<String, MissionChatResponse>> fetchChat({
    required int missionId,
    String? before,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<MissionChatResponse>(
      functionName: 'fetch-squad-mission-chat',
      body: {},
      queryParams: {"missionId": missionId, "before": before},
      fallbackErrorMessage: 'Failed to Fetch Squad Mission Chat',
      onSuccess: (data) => MissionChatResponse.fromJson(data["data"]),
    );
  }

  Future<Either<String, ChatMessage>> sendMissionChat({
    required int missionId,
    required int chatRoomId,
    required String? content,
    required String? replyToId,
    required String? media,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'chatRoomId': chatRoomId,
      'content': content,
      'replyToId': replyToId,
      'media': media != null
          ? await MultipartFile.fromFile(media, filename: media.split('/').last)
          : null,
    });

    final response = await ApiService.instance!.postRequestHandler(
      "functions/v1/send-squad-mission-message",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
      transform: (data) => ChatMessage.fromJson(data),
    );

    if (response.responseSuccessful == true) {
      return Right(response.responseBody!);
    } else {
      return Left(
        response.responseMessage ?? "Failed to Send Squad Mission Message",
      );
    }
  }

  Future<Either<String, String>> submitMission({
    required int missionId,
    required String? image,
    required String text,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
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
