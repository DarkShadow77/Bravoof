part of 'squad_individual_bloc.dart';

enum SquadIndividualType { fetch, complete }

@immutable
class SquadIndividualState {
  final List<SquadMission> missions;

  const SquadIndividualState({required this.missions});

  SquadIndividualState copyWith({List<SquadMission>? missions}) {
    return SquadIndividualState(missions: missions ?? this.missions);
  }
}

class SquadIndividualInitialState extends SquadIndividualState {
  const SquadIndividualInitialState({required super.missions});
}

class SquadIndividualLoadingState extends SquadIndividualState {
  final SquadIndividualType type;
  final int? missionId;

  const SquadIndividualLoadingState({
    required this.type,
    this.missionId,
    required super.missions,
  });
}

class SquadIndividualLoadedState extends SquadIndividualState {
  const SquadIndividualLoadedState({required super.missions});
}

class SquadIndividualSuccessState extends SquadIndividualState {
  final SquadIndividualType type;
  final int? missionId;
  final String message;

  const SquadIndividualSuccessState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}

class SquadIndividualErrorState extends SquadIndividualState {
  final SquadIndividualType type;
  final int? missionId;
  final String message;

  const SquadIndividualErrorState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}
