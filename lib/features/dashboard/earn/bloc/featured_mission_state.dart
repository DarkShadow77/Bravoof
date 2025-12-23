part of 'featured_mission_bloc.dart';

enum FeaturedMissionType { fetchMission, checkCompletedStatus, completeMission }

@immutable
class FeaturedMissionState {
  final List<FeaturedMission> missions;
  final List<MissionStatus> hasJoined;

  FeaturedMissionState({required this.missions, required this.hasJoined});

  FeaturedMissionState copWith({
    List<FeaturedMission>? missions,
    List<MissionStatus>? hasJoined,
  }) {
    return FeaturedMissionState(
      missions: missions ?? this.missions,
      hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}

class FeaturedMissionInitial extends FeaturedMissionState {
  FeaturedMissionInitial({required super.missions, required super.hasJoined});
}

class FeaturedMissionLoading extends FeaturedMissionState {
  final int? missionId;
  final FeaturedMissionType type;
  FeaturedMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class FeaturedMissionError extends FeaturedMissionState {
  final int? missionId;
  final String message;
  final FeaturedMissionType type;
  FeaturedMissionError({
    this.missionId,
    required this.message,
    required this.type,
    required super.missions,
    required super.hasJoined,
  });
}

class FeaturedMissionJoined extends FeaturedMissionState {
  final int missionId;
  FeaturedMissionJoined({
    required this.missionId,
    required super.missions,
    required super.hasJoined,
  });
}
