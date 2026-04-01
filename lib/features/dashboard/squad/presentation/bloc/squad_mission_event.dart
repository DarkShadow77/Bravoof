part of 'squad_mission_bloc.dart';

@immutable
abstract class SquadMissionsEvent {}

class FetchSquadMissionsEvent extends SquadMissionsEvent {}

class CompleteSquadMissionEvent extends SquadMissionsEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteSquadMissionEvent({
    required this.missionId,
    this.image,
    required this.text,
  });
}
