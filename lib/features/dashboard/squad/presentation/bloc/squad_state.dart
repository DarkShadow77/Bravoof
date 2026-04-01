part of 'squad_bloc.dart';

enum SquadType { fetchSquads, joinSquad, leaveSquad }

@immutable
class SquadState {
  final List<Squad> squads;

  SquadState({required this.squads});

  SquadState copWith({List<Squad>? squads}) {
    return SquadState(squads: squads ?? this.squads);
  }
}

class SquadInitialState extends SquadState {
  SquadInitialState({required super.squads});
}

class SquadLoadingState extends SquadState {
  final String? squadId;
  final SquadType type;
  SquadLoadingState({this.squadId, required this.type, required super.squads});
}

class SquadErrorState extends SquadState {
  final String? squadId;
  final String message;
  final SquadType type;
  SquadErrorState({
    this.squadId,
    required this.message,
    required this.type,
    required super.squads,
  });
}

class SquadSuccessState extends SquadState {
  final String? squadId;
  final String message;
  final SquadType type;
  SquadSuccessState({
    this.squadId,
    required this.message,
    required this.type,
    required super.squads,
  });
}
