part of 'new_social_mission_bloc.dart';

enum NewSocialMissionType {
  fetchMission,
  checkCompletedStatus,
  completeMission,
}

@immutable
class NewSocialMissionState {
  final List<NewSocialMission> missions;
  final List<MissionStatus> hasJoined;

  NewSocialMissionState({required this.missions, required this.hasJoined});

  NewSocialMissionState copWith({
    List<NewSocialMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return NewSocialMissionState(
      missions: missions ?? this.missions,
      hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}

class NewSocialMissionInitial extends NewSocialMissionState {
  NewSocialMissionInitial({required super.missions, required super.hasJoined});
}

class NewSocialMissionLoading extends NewSocialMissionState {
  final int? missionId;
  final NewSocialMissionType type;
  NewSocialMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class NewSocialMissionError extends NewSocialMissionState {
  final int? missionId;
  final String message;
  final NewSocialMissionType type;
  NewSocialMissionError({
    this.missionId,
    required this.message,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class NewSocialMissionJoined extends NewSocialMissionState {
  final int missionId;
  NewSocialMissionJoined({
    required this.missionId,
    required super.missions,
    required super.hasJoined,
  });
}
