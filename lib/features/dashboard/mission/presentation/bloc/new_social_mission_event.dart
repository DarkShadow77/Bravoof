part of 'new_social_mission_bloc.dart';

@immutable
abstract class NewSocialMissionEvent {}

class LoadNewSocialMission extends NewSocialMissionEvent {
  LoadNewSocialMission();
}

class CompleteNewSocialMission extends NewSocialMissionEvent {
  final int missionId;
  final String? image;
  final String? text;
  final bool isVideo;

  CompleteNewSocialMission({
    required this.missionId,
    this.image,
    this.text,
    required this.isVideo,
  });
}
