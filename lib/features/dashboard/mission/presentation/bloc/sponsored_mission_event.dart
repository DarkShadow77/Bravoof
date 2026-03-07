part of 'sponsored_mission_bloc.dart';

@immutable
abstract class SponsoredMissionEvent {}

class LoadSponsoredMission extends SponsoredMissionEvent {
  LoadSponsoredMission();
}

class CheckCompletedStatus extends SponsoredMissionEvent {
  final int missionId;
  final int index;
  CheckCompletedStatus({required this.missionId, required this.index});
}

class CompleteSponsoredMission extends SponsoredMissionEvent {
  final int missionId;
  final String? imageUrl;
  final String text;

  CompleteSponsoredMission({
    required this.missionId,
    required this.imageUrl,
    required this.text,
  });
}
