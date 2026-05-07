import 'package:bloc/bloc.dart';
import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../mission/data/model/featured_mission_model.dart';
import '../../../mission/data/model/sponsored_mission_model.dart';
import '../../data/repository/brand_repository.dart';

part 'brand_individual_event.dart';
part 'brand_individual_state.dart';

class BrandIndividualBloc
    extends Bloc<BrandIndividualEvent, BrandIndividualState> {
  final BrandRepository repo;
  final String brandId;

  final supabase = Supabase.instance.client;

  BrandIndividualBloc({required this.repo, required this.brandId})
    : super(
        BrandMissionsInitialState(
          sponsoredMissions: [],
          featuredMissions: [],
          campaigns: [],
        ),
      ) {
    on<FetchBrandMissionsEvent>(_fetchMissions);
    add(FetchBrandMissionsEvent());
    // on<CompleteBrandMissionEvent>(_completeMission);
  }

  Future<void> _fetchMissions(
    FetchBrandMissionsEvent event,
    Emitter<BrandIndividualState> emit,
  ) async {
    emit(
      BrandIndividualLoadingState(
        type: BrandIndividualType.fetch,
        sponsoredMissions: state.sponsoredMissions,
        featuredMissions: state.featuredMissions,
        campaigns: state.campaigns,
      ),
    );

    // Fire all three in parallel
    final results = await Future.wait([
      repo.fetchBrandSponsoredMissions(brandId: brandId),
      repo.fetchBrandFeaturedMissions(brandId: brandId),
      repo.fetchBrandCampaigns(brandId: brandId),
    ]);

    final sponsoredResult = results[0];
    final featuredResult = results[1];
    final campaignsResult = results[2];

    // Fold each — keep existing data on error
    final sponsored = sponsoredResult.fold(
      (_) => state.sponsoredMissions,
      (v) => v as List<SponsoredMission>,
    );
    final featured = featuredResult.fold(
      (_) => state.featuredMissions,
      (v) => v as List<FeaturedMission>,
    );
    final campaigns = campaignsResult.fold(
      (_) => state.campaigns,
      (v) => v as List<CampaignResponseModel>,
    );

    emit(
      BrandIndividualSuccessState(
        type: BrandIndividualType.fetch,
        message: "Brand content fetched",
        sponsoredMissions: sponsored,
        featuredMissions: featured,
        campaigns: campaigns,
      ),
    );
  }
}
