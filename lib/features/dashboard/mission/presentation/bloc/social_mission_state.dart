part of 'social_mission_bloc.dart';

enum SocialMissionType { fetchMission, completeMission }

@immutable
class SocialMissionState {
  final List<SocialMission> missions;

  SocialMissionState({required this.missions});

  SocialMissionState copWith({
    List<SocialMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return SocialMissionState(missions: missions ?? this.missions);
  }
}

class SocialMissionInitial extends SocialMissionState {
  SocialMissionInitial({required super.missions});
}

class SocialMissionLoading extends SocialMissionState {
  final int? missionId;
  final SocialMissionType type;
  SocialMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
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
  });
}

class SocialMissionJoined extends SocialMissionState {
  final int missionId;
  SocialMissionJoined({required this.missionId, required super.missions});
}
