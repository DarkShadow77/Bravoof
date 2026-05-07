part of 'brand_individual_bloc.dart';

enum BrandIndividualType { fetch, complete }

@immutable
class BrandIndividualState {
  final List<SponsoredMission> sponsoredMissions;
  final List<FeaturedMission> featuredMissions;
  final List<CampaignResponseModel> campaigns;

  const BrandIndividualState({
    required this.sponsoredMissions,
    required this.featuredMissions,
    required this.campaigns,
  });

  BrandIndividualState copyWith({
    List<SponsoredMission>? sponsoredMissions,
    List<FeaturedMission>? featuredMissions,
    List<CampaignResponseModel>? campaigns,
  }) {
    return BrandIndividualState(
      sponsoredMissions: sponsoredMissions ?? this.sponsoredMissions,
      featuredMissions: featuredMissions ?? this.featuredMissions,
      campaigns: campaigns ?? this.campaigns,
    );
  }
}

class BrandMissionsInitialState extends BrandIndividualState {
  const BrandMissionsInitialState({
    required super.sponsoredMissions,
    required super.featuredMissions,
    required super.campaigns,
  });
}

class BrandIndividualLoadingState extends BrandIndividualState {
  final BrandIndividualType type;
  final int? missionId;

  const BrandIndividualLoadingState({
    required this.type,
    this.missionId,
    required super.sponsoredMissions,
    required super.featuredMissions,
    required super.campaigns,
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
    required super.sponsoredMissions,
    required super.featuredMissions,
    required super.campaigns,
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
    required super.sponsoredMissions,
    required super.featuredMissions,
    required super.campaigns,
  });
}
