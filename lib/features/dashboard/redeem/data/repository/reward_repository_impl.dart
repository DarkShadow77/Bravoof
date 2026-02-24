import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../redeem_history_model.dart';
import 'redeem_repository.dart';

class RedeemRepositoryImpl extends RedeemRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<RedeemHistory>>> fetchRedeemHistory({
    required String userId,
  }) async {
    try {
      final res = await supabase
          .from('reward_redemptions')
          .select('''
          id,
          reward_type,
          coins_spent,
          metadata,
          created_at
        ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (res.isEmpty) {
        return Right([]);
      }

      final redeemHistory = res.map((e) => RedeemHistory.fromJson(e)).toList();

      return Right(redeemHistory);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> redeemAirtimeData({
    required String rewardType,
    required String phone,
    required String network,
    required String userId,
    required String userName,
    required String email,
    required int coins,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'redeem_airtime_or_data',
      body: {
        'userId': userId,
        'rewardType': rewardType,
        'coins': coins,
        'phone': phone,
        'network': network,
        'name': userName,
        'email': email,
      },
      fallbackErrorMessage: '${rewardType.capitalize} redemption failed',
      onSuccess: (data) => 'Successfully Redeemed ${rewardType.capitalize}',
    );
  }

  Future<Either<String, String>> redeemGiftcard({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required String email,
    required int coins,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'create_giftcard_session',
      body: {
        'userId': userId,
        'rewardType': rewardType,
        'coins': coins,
        'phone': phone,
        'name': userName,
        'email': email,
      },
      fallbackErrorMessage: '${rewardType.capitalize} redemption failed',
      onSuccess: (data) => data['message'],
    );
  }
}
