import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../onbaording/data/model/user_profile.dart';
import '../model/leaderboard_response_model.dart';
import '../model/quote_model.dart';
import '../model/spotlight_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, List<CampaignModel>>> fetchCampaigns() async {
    return ApiService.instance!.invokeEdgeFunction<List<CampaignModel>>(
      functionName: 'fetch-campaigns',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Campaigns',
      onSuccess: (data) {
        final campaign = data["data"] as List;
        return campaign.map((e) => CampaignModel.fromJson(e)).toList();
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

  Future<Either<String, QuoteModel>> fetchQuote() async {
    return ApiService.instance!.invokeEdgeFunction<QuoteModel>(
      functionName: 'fetch-quote',
      body: {},
      fallbackErrorMessage: 'Failed to Retrieve Quote',
      onSuccess: (data) => QuoteModel.fromJson(data["data"]),
    );
  }

  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<UserProfile>>(
      functionName: 'fetch-user-referrals',
      body: {"userId": userId},
      fallbackErrorMessage: 'Failed to Retrieve Users Referral',
      onSuccess: (data) {
        final referral = data["data"] as List;
        return referral.map((e) => UserProfile.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, LeaderboardResponseModel>> fetchLeaderboard({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<LeaderboardResponseModel>(
      functionName: 'fetch-leaderboard',
      body: {"userId": userId},
      fallbackErrorMessage: 'Failed to Retrieve Leaderboard',
      onSuccess: (data) => LeaderboardResponseModel.fromJson(data["data"]),
    );
  }
}
