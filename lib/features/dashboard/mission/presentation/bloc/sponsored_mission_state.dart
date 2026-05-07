part of 'sponsored_mission_bloc.dart';

enum SponsoredMissionType { fetchMission, completeMission }

@immutable
class SponsoredMissionState {
  final List<SponsoredMission> missions;

  SponsoredMissionState({required this.missions});

  SponsoredMissionState copWith({
    List<SponsoredMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return SponsoredMissionState(missions: missions ?? this.missions);
  }
}

class SponsoredMissionInitial extends SponsoredMissionState {
  SponsoredMissionInitial({required super.missions});
}

class SponsoredMissionLoading extends SponsoredMissionState {
  final int? missionId;
  final SponsoredMissionType type;
  SponsoredMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
  });
}

class SponsoredMissionError extends SponsoredMissionState {
  final int? missionId;
  final String message;
  final SponsoredMissionType type;
  SponsoredMissionError({
    this.missionId,
    required this.message,
    required this.type,
    required super.missions,
  });
}

class SponsoredMissionJoined extends SponsoredMissionState {
  final int missionId;
  SponsoredMissionJoined({required this.missionId, required super.missions});
}
