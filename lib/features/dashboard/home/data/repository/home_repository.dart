import 'package:dartz/dartz.dart';
import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import '../model/spotlight_model.dart';

abstract class HomeRepository {
  Future<Either<String, List<CampaignModel>>> fetchCampaigns();

  Future<Either<String, SpotlightModel>> fetchSpotlight();

  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  });
}
