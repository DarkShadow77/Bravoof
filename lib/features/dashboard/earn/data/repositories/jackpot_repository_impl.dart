import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'jackpot_repository.dart';

class JackpotRepositoryImpl extends JackpotRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, Map<String, dynamic>>> spinJackpot({
    required String userId,
  }) async {
    try {
      final res = await supabase.functions.invoke(
        'spin_jackpot',
        body: {'userId': supabase.auth.currentUser!.id},
      );

      Logger().d("Spin Result Response $res");

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
        return Left(data['message'] ?? 'Spin failed');
      }

      final rewardType = data['rewardType'];
      final rewardValue = data['rewardValue'];

      return Right({'rewardType': rewardType, 'rewardValue': rewardValue});
    } catch (e) {
      return Left(e.toString());
    }
  }
}
