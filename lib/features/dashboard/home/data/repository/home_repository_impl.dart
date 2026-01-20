import 'package:dartz/dartz.dart';
import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import '../model/spotlight_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, List<CampaignModel>>> fetchCampaigns() async {
    try {
      var res = await supabase.from('campaigns').select();

      final campaign = res.map((e) => CampaignModel.fromJson(e)).toList();

      return Right(campaign);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SpotlightModel>> fetchSpotlight() async {
    try {
      final res = await supabase
          .from('spotlight')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (res == null) {
        Logger().w("No spotlight record found");
        return Left("No spotlight available");
      }

      Logger().d("Latest spotlight: $res");

      SpotlightModel spotlight = SpotlightModel.fromJson(res);

      return Right(spotlight);
    } on AuthException catch (e) {
      Logger().d("Latest spotlight: ${e.message}");
      return Left(e.message);
    } catch (e) {
      Logger().d("Latest spotlight: ${e.toString()}");
      return Left(e.toString());
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
