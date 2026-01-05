import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    required String userId,
    required String userName,
    required String email,
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
          'email': email,
        },
      );

      Logger().d("Redeem Airtime and Data Response $res");

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(
          data['message'] ?? '${rewardType.capitalize} redemption failed',
        );
      }
      return Right("Successfully Redeemed ${rewardType.capitalize}");
    } catch (e, s) {
      Logger().e("🔥Redeem '${rewardType.capitalize} crashed E:$e, S:$s");
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> redeemGiftcard({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required String email,
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
          'email': email,
        },
      );

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(data['message'] ?? 'Gift card redemption failed');
      }

      final redirectUrl = data['redirectUrl'];

      if (redirectUrl == null || redirectUrl is! String) {
        return Left('Gift card created but redirect URL is missing');
      }

      return Right(redirectUrl);
    } catch (e, s) {
      Logger().e("🔥 redeemGiftcard crashed E:$e, S:$s");
      return Left(e.toString());
    }
  }
}
