import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import 'campaign_repository.dart';

class CampaignRepositoryImpl extends CampaignRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /*Future<Either<String, int>> getTotalJoinedForCampaign({
    required int campaignId,
  }) async {
    try {
      log("Total Joined Campaign Getting");
      final res = await supabase
          .from('campaign_participants')
          .select('id')
          .eq('campaign_id', campaignId)
          .count(CountOption.exact);

      final totalJoined = res.count ?? 0;
      log("Total Joined Campaign $totalJoined");
      return Right(totalJoined);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<UserProfile>>> getUserReferralsForCampaign({
    required String userId,
    required int campaignId,
  }) async {
    try {
      // 1️⃣ Fetch campaign date range
      final campaign = await supabase
          .from('campaigns')
          .select('created_at, campaign_end_date')
          .eq('id', campaignId)
          .single();

      final DateTime campaignStart = DateTime.parse(campaign['created_at']);
      final DateTime campaignEnd = DateTime.parse(
        campaign['campaign_end_date'],
      );

      // 2️⃣ Fetch referrals within campaign range
      final referrals = await supabase
          .from('referrals')
          .select('''
            referred_user_id,
            created_at,
            user_profile (
              name,
              email,
              profile_image
            )
          ''')
          .eq('referrer_user_id', userId)
          .gte('created_at', campaignStart.toIso8601String())
          .lte('created_at', campaignEnd.toIso8601String())
          .order('created_at', ascending: true);

      // 3️⃣ Normalize response
      final result = referrals.map<Map<String, dynamic>>((r) {
        return {
          'referred_user_id': r['referred_user_id'],
          'name': r['user_profile']?['name'],
          'email': r['user_profile']?['email'],
          'profile_image': r['user_profile']?['profile_image'],
          'created_at': r['created_at'],
        };
      }).toList();

      final userList = result.map((e) => UserProfile.fromJson(e)).toList();

      return Right(userList);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<bool> isUserInCampaign({
    required int campaignId,
    required String userId,
  }) async {
    log("Is User In Campaign");
    final res = await supabase
        .from('campaign_participants')
        .select('id')
        .eq('campaign_id', campaignId)
        .eq('user_id', userId)
        .maybeSingle();

    log("Is User In Campaign $res");

    return res != null;
  }*/

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
      onSuccess: (data) => 'Winner reward claimed!',
    );
  }
}
