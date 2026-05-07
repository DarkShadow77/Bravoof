part of 'community_mission_bloc.dart';

enum CommunityMissionType { fetchMission, /*checkJoinStatus,*/ joinMission }

@immutable
class CommunityMissionState {
  final CommunityMission? mission;
  // final MissionStatus hasJoined;

  CommunityMissionState({required this.mission,/* required this.hasJoined*/});

  CommunityMissionState copWith({
    CommunityMission? mission,
    // MissionStatus? hasJoined,
  }) {
    return CommunityMissionState(
      mission: mission ?? this.mission,
      // hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}

class CommunityMissionInitial extends CommunityMissionState {
  CommunityMissionInitial({required super.mission, /*required super.hasJoined*/});
}

class CommunityMissionLoading extends CommunityMissionState {
  final CommunityMissionType type;
  CommunityMissionLoading({
    required this.type,
    required super.mission,
    // required super.hasJoined,
  });
}

class CommunityMissionError extends CommunityMissionState {
  final String message;
  final CommunityMissionType type;
  CommunityMissionError({
    required this.message,
    required this.type,
    required super.mission,
    // required super.hasJoined,
  });
}

class CommunityMissionJoined extends CommunityMissionState {
  CommunityMissionJoined({required super.mission,/* required super.hasJoined*/});
}
