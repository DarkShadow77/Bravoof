import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, CampaignResponse>> fetchCampaigns() async {
    try {
      var res = await supabase.from('campaigns').select();

      CampaignResponse campaignResponse = CampaignResponse.fromJson({
        "campaign": res,
      });
      return Right(campaignResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, List<UserProfile>>> getAllUserReferrals({
    required String userId,
  }) async {
    try {
      final referrals = await supabase
          .from('referrals')
          .select('''
          referred_user_id,
          created_at,
          user_profile (
            name,
            email,
            profile_image,
            created_at
          )
        ''')
          .eq('referrer_user_id', userId)
          .order('created_at', ascending: true);

      final result = referrals.map<Map<String, dynamic>>((r) {
        return {
          'user_id': r['referred_user_id'],
          'name': r['user_profile']?['name'],
          'email': r['user_profile']?['email'],
          'profile_image': r['user_profile']?['profile_image'],

          // 🟢 When the referral happened
          'referred_at': r['created_at'],

          // 🟢 When the user joined Bravoo
          'created_at': r['user_profile']?['created_at'],
        };
      }).toList();

      final userList = result.map((e) => UserProfile.fromJson(e)).toList();

      return Right(userList);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
