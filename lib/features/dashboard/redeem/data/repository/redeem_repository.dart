import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../redeem_history_model.dart';

abstract class RedeemRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<RedeemHistory>>> fetchRedeemHistory({
    required String userId,
  });

  Future<Either<String, String>> redeemAirtimeData({
    required String rewardType,
    required String phone,
    required String network,
    required String userId,
    required String userName,
    required String email,
    required int coins,
  });

  Future<Either<String, String>> redeemGiftcard({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required String email,
    required int coins,
  });

  Future<Either<String, String>> redeemPaypal({
    required String userId,
    required String userName,
    required String email,
  });
}
