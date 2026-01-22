import 'package:Bravoo/session/session_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/rewards_summary_response.dart';

class MissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  Future<Either<String, RewardsSummaryResponse>> fetchAllUsersReward() async {
    try {
      final allUsersReward = await supabase
          .from('user_rewards_summary')
          .select(
            'total_point_redeemed, user_id, user_profile(name, profile_image, bio)',
          )
          .order('total_points', ascending: false); // Sort by points descending

      print(allUsersReward);

      if (allUsersReward != null) {
        RewardsSummaryResponse rewardsSummaryResponse =
            RewardsSummaryResponse.fromJson({"rewards": allUsersReward});

        return Right(rewardsSummaryResponse);
      } else {
        return Left("Empty");
      }
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }
}
