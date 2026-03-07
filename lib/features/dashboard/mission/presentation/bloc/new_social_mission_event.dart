part of 'new_social_mission_bloc.dart';

@immutable
abstract class NewSocialMissionEvent {}

class LoadNewSocialMission extends NewSocialMissionEvent {
  LoadNewSocialMission();
}

class CheckCompletedStatus extends NewSocialMissionEvent {
  final int missionId;
  final int index;
  CheckCompletedStatus({required this.missionId, required this.index});
}

class CompleteNewSocialMission extends NewSocialMissionEvent {
  final int missionId;
  final String imageUrl;
  final String text;

  CompleteNewSocialMission({
    required this.missionId,
    required this.imageUrl,
    required this.text,
  });
}
