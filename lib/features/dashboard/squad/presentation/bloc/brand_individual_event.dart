part of 'brand_individual_bloc.dart';

@immutable
abstract class BrandIndividualEvent {}

class FetchBrandMissionsEvent extends BrandIndividualEvent {}

class CompleteBrandMissionEvent extends BrandIndividualEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteBrandMissionEvent({
    required this.missionId,
    this.image,
    required this.text,
  });
}
