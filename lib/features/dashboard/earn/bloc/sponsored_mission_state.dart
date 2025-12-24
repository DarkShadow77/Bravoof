part of 'sponsored_mission_bloc.dart';

enum SponsoredMissionType {
  fetchMission,
  checkCompletedStatus,
  completeMission,
}

@immutable
class SponsoredMissionState {
  final List<SponsoredMission> missions;
  final List<MissionStatus> hasJoined;

  SponsoredMissionState({required this.missions, required this.hasJoined});

  SponsoredMissionState copWith({
    List<SponsoredMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return SponsoredMissionState(
      missions: missions ?? this.missions,
      hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}

class SponsoredMissionInitial extends SponsoredMissionState {
  SponsoredMissionInitial({required super.missions, required super.hasJoined});
}

class SponsoredMissionLoading extends SponsoredMissionState {
  final int? missionId;
  final SponsoredMissionType type;
  SponsoredMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
    required super.hasJoined,
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
    required super.hasJoined,
  });
}

class SponsoredMissionJoined extends SponsoredMissionState {
  final int missionId;
  SponsoredMissionJoined({
    required this.missionId,
    required super.missions,
    required super.hasJoined,
  });
}
