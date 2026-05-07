part of 'sponsored_mission_bloc.dart';

@immutable
abstract class SponsoredMissionEvent {}

class LoadSponsoredMission extends SponsoredMissionEvent {
  LoadSponsoredMission();
}

class CompleteSponsoredMission extends SponsoredMissionEvent {
  final int missionId;
  final String? image;
  final String? text;
  final bool isVideo;

  CompleteSponsoredMission({
    required this.missionId,
    this.image,
    this.text,
    required this.isVideo,
  });
}
