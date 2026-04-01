part of 'brand_mission_bloc.dart';

enum BrandMissionsType { fetch, complete }

@immutable
abstract class BrandMissionsState {
  final List<BrandMission> missions;

  const BrandMissionsState({required this.missions});
}

class BrandMissionsInitialState extends BrandMissionsState {
  const BrandMissionsInitialState({required super.missions});
}

class BrandMissionsLoadingState extends BrandMissionsState {
  final BrandMissionsType type;
  final int? missionId;

  const BrandMissionsLoadingState({
    required this.type,
    this.missionId,
    required super.missions,
  });
}

class BrandMissionsLoadedState extends BrandMissionsState {
  const BrandMissionsLoadedState({required super.missions});
}

class BrandMissionsSuccessState extends BrandMissionsState {
  final BrandMissionsType type;
  final int? missionId;
  final String message;

  const BrandMissionsSuccessState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}

class BrandMissionsErrorState extends BrandMissionsState {
  final BrandMissionsType type;
  final int? missionId;
  final String message;

  const BrandMissionsErrorState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}
