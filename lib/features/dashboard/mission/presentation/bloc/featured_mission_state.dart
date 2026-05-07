part of 'featured_mission_bloc.dart';

enum FeaturedMissionType { fetchMission, completeMission }

@immutable
class FeaturedMissionState {
  final List<FeaturedMission> missions;

  FeaturedMissionState({required this.missions});

  FeaturedMissionState copWith({List<FeaturedMission>? missions}) {
    return FeaturedMissionState(missions: missions ?? this.missions);
  }
}

class FeaturedMissionInitial extends FeaturedMissionState {
  FeaturedMissionInitial({required super.missions});
}

class FeaturedMissionLoading extends FeaturedMissionState {
  final int? missionId;
  final FeaturedMissionType type;
  FeaturedMissionLoading({
    this.missionId,
    required this.type,
    required super.missions,
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
  });
}

class FeaturedMissionJoined extends FeaturedMissionState {
  final int missionId;
  FeaturedMissionJoined({required this.missionId, required super.missions});
}
