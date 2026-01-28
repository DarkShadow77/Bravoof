import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:dartz/dartz.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import '../model/leaderboard_response_model.dart';
import '../model/quote_model.dart';
import '../model/spotlight_model.dart';

abstract class HomeRepository {
  Future<Either<String, List<CampaignModel>>> fetchCampaigns();
  Future<Either<String, SpotlightModel>> fetchSpotlight();
  Future<Either<String, QuoteModel>> fetchQuote();
  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  });
  Future<Either<String, LeaderboardResponseModel>> fetchLeaderboard({
    required String userId,
  });
}
