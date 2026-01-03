import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'redeem_repository.dart';

class RedeemRepositoryImpl extends RedeemRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, String>> redeemAirtimeData({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required int coins,
  }) async {
    try {
      final res = await supabase.functions.invoke(
        'redeem_airtime_or_data',
        body: {
          'userId': userId,
          'rewardType': rewardType,
          'coins': coins,
          'phone': phone,
          'name': userName,
        },
      );

      Logger().d("Redeem Airtime and Data Response $res");

      if (res.status != 200) {
        return Left(res.data['message'] ?? 'Something went wrong');
      }

      final success = res.data['success'] as bool;
      final message = res.data['message'] as String;

      if (!success) {
        return Left(message);
      }

      return Right(message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> redeemGiftcard({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required int coins,
  }) async {
    try {
      final res = await supabase.functions.invoke(
        'create_giftcard_session',
        body: {
          'userId': userId,
          'rewardType': rewardType,
          'coins': coins,
          'phone': phone,
          'name': userName,
        },
      );

      Logger().d("Redeem Giftcard Response $res");

      return Right(res.data['redirectUrl']);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
