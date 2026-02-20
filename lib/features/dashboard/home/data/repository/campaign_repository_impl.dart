import 'package:bravoo/features/dashboard/profile/data/model/user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import 'campaign_repository.dart';

class CampaignRepositoryImpl extends CampaignRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, int>> getTotalJoinedForCampaign({
    required int campaignId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<int>(
      functionName: 'get-campaign-total-joined',
      body: {'campaignId': campaignId},
      fallbackErrorMessage: 'Failed to get campaign participant count',
      onSuccess: (data) => data['data'] as int,
    );
  }

  @override
  Future<Either<String, List<UserProfile>>> getUserReferralsForCampaign({
    required String userId,
    required int campaignId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<UserProfile>>(
      functionName: 'get-campaign-referrals',
      body: {'userId': userId, 'campaignId': campaignId},
      fallbackErrorMessage: 'Failed to get campaign referrals',
      onSuccess: (data) {
        final List<dynamic> referralsList = data['data'] as List<dynamic>;
        return referralsList
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<String, bool>> isUserInCampaign({
    required int campaignId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<bool>(
      functionName: 'check-user-in-campaign',
      body: {'userId': userId, 'campaignId': campaignId},
      fallbackErrorMessage: 'Failed to check campaign participation',
      onSuccess: (data) => data['data'] as bool,
    );
  }

  @override
  Future<Either<String, bool>> hasUserClaimedReward({
    required int campaignId,
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<bool>(
      functionName: 'check-campaign-reward-claimed',
      body: {'userId': userId, 'campaignId': campaignId},
      fallbackErrorMessage: 'Failed to check reward claim status',
      onSuccess: (data) => data['data'] as bool,
    );
  }

  Future<Either<String, String>> claimParticipantReward({
    required String userId,
    required int campaignId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'mark-campaign-reward-claimed',
      body: {'userId': userId, 'campaignId': campaignId},
      fallbackErrorMessage: 'Failed to claim participant reward',
      onSuccess: (data) => data['message'] ?? 'Reward claimed successfully!',
    );
  }

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
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'claim-campaign-winner-reward',
      body: {
        'userId': userId,
        'campaignId': campaignId,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'country': country,
        'deliveryAddress': deliveryAddress,
        'city': city,
        'state': state,
      },
      fallbackErrorMessage: 'Failed to claim winner reward',
      onSuccess: (data) => data['message'] ?? 'Winner reward claimed!',
    );
  }
}
