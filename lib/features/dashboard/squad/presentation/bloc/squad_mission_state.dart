part of 'squad_mission_bloc.dart';

enum SquadMissionsType { fetch, complete }

@immutable
abstract class SquadMissionsState {
  final List<SquadMission> missions;

  const SquadMissionsState({required this.missions});
}

class SquadMissionsInitialState extends SquadMissionsState {
  const SquadMissionsInitialState({required super.missions});
}

class SquadMissionsLoadingState extends SquadMissionsState {
  final SquadMissionsType type;
  final int? missionId;

  const SquadMissionsLoadingState({
    required this.type,
    this.missionId,
    required super.missions,
  });
}

class SquadMissionsLoadedState extends SquadMissionsState {
  const SquadMissionsLoadedState({required super.missions});
}

class SquadMissionsSuccessState extends SquadMissionsState {
  final SquadMissionsType type;
  final int? missionId;
  final String message;

  const SquadMissionsSuccessState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}

class SquadMissionsErrorState extends SquadMissionsState {
  final SquadMissionsType type;
  final int? missionId;
  final String message;

  const SquadMissionsErrorState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}
