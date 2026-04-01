part of 'brand_mission_bloc.dart';

@immutable
abstract class BrandMissionsEvent {}

class FetchBrandMissionsEvent extends BrandMissionsEvent {}

class CompleteBrandMissionEvent extends BrandMissionsEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteBrandMissionEvent({
    required this.missionId,
    this.image,
    required this.text,
  });
}
