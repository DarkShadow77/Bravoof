part of 'brand_individual_bloc.dart';

enum BrandIndividualType { fetch, complete }

@immutable
class BrandIndividualState {
  final List<BrandMission> missions;

  const BrandIndividualState({required this.missions});

  BrandIndividualState copyWith({List<BrandMission>? missions}) {
    return BrandIndividualState(missions: missions ?? this.missions);
  }
}

class BrandMissionsInitialState extends BrandIndividualState {
  const BrandMissionsInitialState({required super.missions});
}

class BrandIndividualLoadingState extends BrandIndividualState {
  final BrandIndividualType type;
  final int? missionId;

  const BrandIndividualLoadingState({
    required this.type,
    this.missionId,
    required super.missions,
  });
}

class BrandIndividualSuccessState extends BrandIndividualState {
  final BrandIndividualType type;
  final int? missionId;
  final String message;

  const BrandIndividualSuccessState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}

class BrandIndividualErrorState extends BrandIndividualState {
  final BrandIndividualType type;
  final int? missionId;
  final String message;

  const BrandIndividualErrorState({
    required this.type,
    this.missionId,
    required this.message,
    required super.missions,
  });
}
