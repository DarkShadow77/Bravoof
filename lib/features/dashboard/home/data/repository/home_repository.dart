import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:dartz/dartz.dart';

import '../../../profile/data/model/user_profile.dart';
import '../model/dynamic_carousel_model.dart';
import '../model/home_message_model.dart';
import '../model/leaderboard_response_model.dart';
import '../model/quote_model.dart';
import '../model/spotlight_model.dart';

abstract class HomeRepository {
  Future<Either<String, List<CampaignResponseModel>>> fetchCampaigns();
  Future<Either<String, List<SpotlightModel>>> fetchSpotlights();
  Future<Either<String, SpotlightModel>> fetchSpotlight();
  Future<Either<String, HomeMessageModel>> fetchHomeMessage();
  Future<Either<String, List<DynamicCarouselModel>>> fetchExtraHomeCard();
  Future<Either<String, QuoteModel>> fetchQuote();
  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  });
  Future<Either<String, LeaderboardResponseModel>> fetchLeaderboard({
    required String userId,
  });
}
