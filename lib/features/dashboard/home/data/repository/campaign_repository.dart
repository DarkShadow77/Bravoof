import 'package:dartz/dartz.dart';

import '../../../../onbaording/data/model/user_profile.dart';

abstract class CampaignRepository {
  Future<Either<String, int>> getTotalJoinedForCampaign({
    required int campaignId,
  });

  Future<Either<String, List<UserProfile>>> getUserReferralsForCampaign({
    required String userId,
    required int campaignId,
  });

  Future<bool> isUserInCampaign({
    required int campaignId,
    required String userId,
  });
}
