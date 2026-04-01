part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {}

class FetchBrandsEvent extends BrandEvent {
  FetchBrandsEvent();
}

class FollowUnfollowBrandEvent extends BrandEvent {
  final String brandId;
  FollowUnfollowBrandEvent({required this.brandId});
}

class FetchBrandMissionsEvent extends BrandEvent {
  final String brandId;
  FetchBrandMissionsEvent({required this.brandId});
}

class CompleteBrandMission extends BrandEvent {
  final int missionId;
  final String? image;
  final String text;

  CompleteBrandMission({
    required this.missionId,
    this.image,
    required this.text,
  });
}
