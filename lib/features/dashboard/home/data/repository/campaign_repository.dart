import 'package:dartz/dartz.dart';

import '../../../profile/data/model/user_profile.dart';

abstract class CampaignRepository {
  Future<Either<String, int>> getTotalJoinedForCampaign({
    required int campaignId,
  });

  Future<Either<String, List<UserProfile>>> getUserReferralsForCampaign({
    required String userId,
    required int campaignId,
  });

  Future<Either<String, bool>> isUserInCampaign({
    required int campaignId,
    required String userId,
  });

  Future<Either<String, bool>> hasUserClaimedReward({
    required int campaignId,
    required String userId,
  });

  Future<Either<String, String>> claimParticipantReward({
    required String userId,
    required int campaignId,
  });

  Future<Either<String, String>> claimWinnerReward({
    required String userId,
    required int campaignId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String country,
    required String deliveryAddress,
    required String city,
    required String state,
  });
}
