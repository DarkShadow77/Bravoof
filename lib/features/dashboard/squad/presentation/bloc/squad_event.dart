part of 'squad_bloc.dart';

@immutable
abstract class SquadEvent {}

class FetchSquadsEvent extends SquadEvent {
  final String? squadId;
  FetchSquadsEvent({this.squadId});
}

class JoinSquadEvent extends SquadEvent {
  final String squadId;
  JoinSquadEvent({required this.squadId});
}

class LeaveSquadEvent extends SquadEvent {
  final String squadId;
  LeaveSquadEvent({required this.squadId});
}

class FetchSquadMissionsEvent extends SquadEvent {
  final String squadId;
  FetchSquadMissionsEvent({required this.squadId});
}

class CompleteSquadMission extends SquadEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteSquadMission({
    required this.missionId,
    this.image,
    required this.text,
  });
}
