part of 'community_mission_bloc.dart';

@immutable
abstract class CommunityMissionEvent {}

class LoadCommunityMission extends CommunityMissionEvent {
  LoadCommunityMission();
}

class CheckJoinStatus extends CommunityMissionEvent {
  CheckJoinStatus();
}

class JoinCommunityMission extends CommunityMissionEvent {
  final int missionId;
  final String? image;
  final String? text;
  final bool isVideo;

  JoinCommunityMission({
    required this.missionId,
    this.image,
    this.text,
    required this.isVideo,
  });
}
