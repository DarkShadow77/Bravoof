part of 'featured_mission_bloc.dart';

@immutable
abstract class FeaturedMissionEvent {}

class LoadFeaturedMission extends FeaturedMissionEvent {
  LoadFeaturedMission();
}

class CheckCompletedStatus extends FeaturedMissionEvent {
  final int missionId;
  final int index;
  CheckCompletedStatus({required this.missionId, required this.index});
}

class CompleteFeaturedMission extends FeaturedMissionEvent {
  final int missionId;
  final String? text;
  final String? imageUrl;

  CompleteFeaturedMission({required this.missionId, this.text, this.imageUrl});
}
