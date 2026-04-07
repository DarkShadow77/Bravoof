part of 'squad_individual_bloc.dart';

@immutable
abstract class SquadIndividualEvent {}

class FetchSquadMissionsEvent extends SquadIndividualEvent {}

class CompleteSquadMissionEvent extends SquadIndividualEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteSquadMissionEvent({
    required this.missionId,
    this.image,
    required this.text,
  });
}
