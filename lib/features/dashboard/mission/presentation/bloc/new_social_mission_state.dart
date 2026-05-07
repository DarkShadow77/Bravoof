part of 'new_social_mission_bloc.dart';

enum NewSocialMissionType { fetchMission, completeMission }

@immutable
class NewSocialMissionState {
  final List<NewSocialMission> missions;

  NewSocialMissionState({required this.missions});

  NewSocialMissionState copWith({List<NewSocialMission>? missions}) {
    return NewSocialMissionState(missions: missions ?? this.missions);
  }
}

class NewSocialMissionInitial extends NewSocialMissionState {
  NewSocialMissionInitial({required super.missions});
}

class NewSocialMissionLoading extends NewSocialMissionState {
  final int? missionId;
  final NewSocialMissionType type;
  NewSocialMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
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
  });
}

class NewSocialMissionJoined extends NewSocialMissionState {
  final int missionId;
  NewSocialMissionJoined({required this.missionId, required super.missions});
}
