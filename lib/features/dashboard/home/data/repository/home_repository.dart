import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/model/campaign_response.dart';

import '../../../../onbaording/data/model/user_profile.dart';

abstract class HomeRepository {
  Future<Either<String, CampaignResponse>> fetchCampaigns();

  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  });
}
