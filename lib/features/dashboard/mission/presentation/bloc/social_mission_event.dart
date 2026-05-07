part of 'social_mission_bloc.dart';

@immutable
abstract class SocialMissionEvent {}

class LoadSocialMission extends SocialMissionEvent {
  LoadSocialMission();
}

class CompleteSocialMission extends SocialMissionEvent {
  final int missionId;
  final String? image;
  final String? text;
  final bool isVideo;

  CompleteSocialMission({
    required this.missionId,
    this.image,
    this.text,
    required this.isVideo,
  });
}
