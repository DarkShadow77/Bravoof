import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:bravoo/features/dashboard/mission/data/model/featured_mission_model.dart';
import 'package:bravoo/features/dashboard/mission/data/model/sponsored_mission_model.dart';
import 'package:dartz/dartz.dart';

import '../model/response/brand_model.dart';

abstract class BrandRepository {
  Future<Either<String, List<Brand>>> fetchBrands();

  Future<Either<String, String>> followUnfollowBrand({required String brandId});

  Future<Either<String, List<SponsoredMission>>> fetchBrandSponsoredMissions({
    required String brandId,
  });
  Future<Either<String, List<FeaturedMission>>> fetchBrandFeaturedMissions({
    required String brandId,
  });
  Future<Either<String, List<CampaignResponseModel>>> fetchBrandCampaigns({
    required String brandId,
  });
}
