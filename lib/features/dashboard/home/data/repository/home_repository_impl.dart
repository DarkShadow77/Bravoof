import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/services/api_service.dart';
import '../../../profile/data/model/users_model.dart';
import '../model/dynamic_carousel_model.dart';
import '../model/home_message_model.dart';
import '../model/leaderboard_response_model.dart';
import '../model/quote_model.dart';
import '../model/spotlight_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  Future<Either<String, List<CampaignResponseModel>>> fetchCampaigns() async {
    return ApiService.instance!.invokeEdgeFunction<List<CampaignResponseModel>>(
      functionName: 'fetch-campaigns',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Campaigns',
      onSuccess: (data) {
        final campaign = data["data"] as List;
        return campaign.map((e) => CampaignResponseModel.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, List<DynamicCarouselModel>>>
  fetchExtraHomeCard() async {
    return ApiService.instance!.invokeEdgeFunction<List<DynamicCarouselModel>>(
      functionName: 'fetch-extra-home-card',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Extra Home Card',
      onSuccess: (data) {
        final campaign = data["data"] as List;
        return campaign.map((e) => DynamicCarouselModel.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, List<SpotlightModel>>> fetchSpotlights() async {
    return ApiService.instance!.invokeEdgeFunction<List<SpotlightModel>>(
      functionName: 'fetch-spotlights',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Spotlight',
      onSuccess: (data) {
        final spotlight = data["data"] as List;
        return spotlight.map((e) => SpotlightModel.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, SpotlightModel>> fetchSpotlight() async {
    return ApiService.instance!.invokeEdgeFunction<SpotlightModel>(
      functionName: 'fetch-spotlight',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Spotlight',
      onSuccess: (data) => SpotlightModel.fromJson(data["data"]),
    );
  }

  Future<Either<String, HomeMessageModel>> fetchHomeMessage() async {
    return ApiService.instance!.invokeEdgeFunction<HomeMessageModel>(
      functionName: 'fetch-home-message',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Home Message',
      onSuccess: (data) => HomeMessageModel.fromJson(data["data"]),
    );
  }

  Future<Either<String, QuoteModel>> fetchQuote() async {
    return ApiService.instance!.invokeEdgeFunction<QuoteModel>(
      functionName: 'fetch-quote',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Quote',
      onSuccess: (data) => QuoteModel.fromJson(data["data"]),
    );
  }

  Future<Either<String, List<Users>>> getAllUserReferrals() async {
    return ApiService.instance!.invokeEdgeFunction<List<Users>>(
      functionName: 'fetch-user-referrals',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Users Referral',
      onSuccess: (data) {
        final referral = data["data"] as List;
        return referral.map((e) => Users.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, LeaderboardResponseModel>> fetchLeaderboard() async {
    return ApiService.instance!.invokeEdgeFunction<LeaderboardResponseModel>(
      functionName: 'fetch-leaderboard',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Leaderboard',
      onSuccess: (data) => LeaderboardResponseModel.fromJson(data["data"]),
    );
  }
}
