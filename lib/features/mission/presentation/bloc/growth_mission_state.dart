part of 'growth_mission_bloc.dart';

enum GrowthMissionType { fetchMission, completeMission }

@immutable
class GrowthMissionState {
  final List<Mission> missions;

  GrowthMissionState({required this.missions});

  GrowthMissionState copWith({List<Mission>? missions}) {
    return GrowthMissionState(missions: missions ?? this.missions);
  }
}

class GrowthMissionInitialState extends GrowthMissionState {
  GrowthMissionInitialState({required super.missions});
}

class GrowthMissionLoadingState extends GrowthMissionState {
  final GrowthMissionType type;
  GrowthMissionLoadingState({required this.type, required super.missions});
}

class GrowthMissionFailureState extends GrowthMissionState {
  final String message;
  final GrowthMissionType type;
  GrowthMissionFailureState({
    required this.message,
    required this.type,
    required super.missions,
  });
}

class GrowthMissionSuccessState extends GrowthMissionState {
  final String message;
  final GrowthMissionType type;
  GrowthMissionSuccessState({
    required this.message,
    required this.type,
    required super.missions,
  });
}
