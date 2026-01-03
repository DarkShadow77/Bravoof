part of 'social_mission_bloc.dart';

enum SocialMissionType { fetchMission, checkCompletedStatus, completeMission }

@immutable
class SocialMissionState {
  final List<SocialMission> missions;
  final List<MissionStatus> hasJoined;

  SocialMissionState({required this.missions, required this.hasJoined});

  SocialMissionState copWith({
    List<SocialMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return SocialMissionState(
      missions: missions ?? this.missions,
      hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}

class SocialMissionInitial extends SocialMissionState {
  SocialMissionInitial({required super.missions, required super.hasJoined});
}

class SocialMissionLoading extends SocialMissionState {
  final int? missionId;
  final SocialMissionType type;
  SocialMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class SocialMissionError extends SocialMissionState {
  final int? missionId;
  final String message;
  final SocialMissionType type;
  SocialMissionError({
    this.missionId,
    required this.message,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class SocialMissionJoined extends SocialMissionState {
  final int missionId;
  SocialMissionJoined({
    required this.missionId,
    required super.missions,
    required super.hasJoined,
  });
}
