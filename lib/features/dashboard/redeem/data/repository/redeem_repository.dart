import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RedeemRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, String>> redeemAirtimeData({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required int coins,
  });

  Future<Either<String, String>> redeemGiftcard({
    required String rewardType,
    required String phone,
    required String userId,
    required String userName,
    required int coins,
  });
}
