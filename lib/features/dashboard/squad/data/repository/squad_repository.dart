import 'package:bravoo/features/dashboard/squad/data/model/response/squad_mission_model.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:dartz/dartz.dart';

import '../model/response/squad_mission_chat_model.dart';

abstract class SquadRepository {
  Future<Either<String, List<Squad>>> fetchSquads({String? squadId});

  Future<Either<String, String>> joinSquad({required String squadId});

  Future<Either<String, String>> leaveSquad({required String squadId});

  Future<Either<String, List<SquadMission>>> fetchSquadMissions({
    required String squadId,
  });

  Future<Either<String, JoinedSquadMission>> joinSquadMission({
    required int missionId,
    required String squadId,
  });

  Future<Either<String, MissionChatMembers>> fetchMissionMembers({
    required int missionId,
    required String squadId,
  });

  Future<Either<String, String>> leaveSquadMission({
    required int missionId,
    required String squadId,
  });

  Future<Either<String, MissionChatResponse>> fetchChat({
    required int missionId,
    required String squadId,
    String? before,
  });

  Future<Either<String, ChatMessage>> sendMissionChat({
    required int missionId,
    required int chatRoomId,
    required String? content,
    required String? replyToId,
    required String? media,
  });

  Future<Either<String, String>> submitMission({
    required int missionId,
    required String squadId,
    required String? image,
    required String? text,
    required bool isVideo,
  });
}
