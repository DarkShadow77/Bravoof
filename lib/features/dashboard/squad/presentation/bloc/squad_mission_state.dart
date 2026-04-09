part of 'squad_mission_bloc.dart';

enum SquadMissionType {
  joinMission,
  fetchMissionMembers,
  leaveMission,
  fetchChat,
  fetchMoreChat,
  sendMissionChat,
  retrySendMissionChat,
  submitMission,
}

@immutable
class SquadMissionState {
  final List<MissionChatMember> missionMembers;
  final MissionChatResponse? chatResponse;
  final List<String> typingUserIds;

  const SquadMissionState({
    required this.missionMembers,
    this.chatResponse,
    this.typingUserIds = const [],
  });

  SquadMissionState copWith({
    List<MissionChatMember>? missionMembers,
    MissionChatResponse? chatResponse,
    List<String>? typingUserIds,
  }) {
    return SquadMissionState(
      missionMembers: missionMembers ?? this.missionMembers,
      chatResponse: chatResponse ?? this.chatResponse,
      typingUserIds: typingUserIds ?? this.typingUserIds,
    );
  }
}

class SquadMissionInitialState extends SquadMissionState {
  const SquadMissionInitialState({
    required super.missionMembers,
    required super.chatResponse,
  });
}

class SquadMissionLoadingState extends SquadMissionState {
  final SquadMissionType type;
  final int missionId;

  const SquadMissionLoadingState({
    required this.type,
    required this.missionId,
    required super.missionMembers,
    required super.chatResponse,
  });
}

class SquadMissionSuccessState extends SquadMissionState {
  final SquadMissionType type;
  final int missionId;
  final String message;

  const SquadMissionSuccessState({
    required this.type,
    required this.missionId,
    required this.message,
    required super.missionMembers,
    required super.chatResponse,
  });
}

class JoinedSquadMissionState extends SquadMissionState {
  final JoinedSquadMission joinedSquadMission;
  final int missionId;

  const JoinedSquadMissionState({
    required this.joinedSquadMission,
    required this.missionId,
    required super.missionMembers,
    required super.chatResponse,
  });
}

class SquadMissionErrorState extends SquadMissionState {
  final SquadMissionType type;
  final int missionId;
  final String message;

  const SquadMissionErrorState({
    required this.type,
    required this.missionId,
    required this.message,
    required super.missionMembers,
    required super.chatResponse,
  });
}
