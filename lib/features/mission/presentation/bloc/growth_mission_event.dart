part of 'growth_mission_bloc.dart';

@immutable
abstract class GrowthMissionEvent {}

class LoadGrowthMission extends GrowthMissionEvent {
  LoadGrowthMission();
}

class CompleteGrowthMission extends GrowthMissionEvent {
  final Map<String, dynamic> mission;

  CompleteGrowthMission({required this.mission});
}
