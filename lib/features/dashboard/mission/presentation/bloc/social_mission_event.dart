part of 'social_mission_bloc.dart';

@immutable
abstract class SocialMissionEvent {}

class LoadSocialMission extends SocialMissionEvent {
  LoadSocialMission();
}

class CheckCompletedStatus extends SocialMissionEvent {
  final int missionId;
  final int index;
  CheckCompletedStatus({required this.missionId, required this.index});
}

class CompleteSocialMission extends SocialMissionEvent {
  final int missionId;
  final String text;

  CompleteSocialMission({required this.missionId, required this.text});
}
