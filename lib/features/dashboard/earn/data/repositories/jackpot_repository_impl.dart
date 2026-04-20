import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import 'jackpot_repository.dart';

class JackpotRepositoryImpl extends JackpotRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, Map<String, dynamic>>> spinJackpot() async {
    return ApiService.instance!.invokeEdgeFunction<Map<String, dynamic>>(
      functionName: 'spin-jackpot',
      body: {},
      fallbackErrorMessage: "Spin failed",
      onSuccess: (data) {
        final rewardType = data['rewardType'];
        final rewardValue = data['rewardValue'];
        return {'rewardType': rewardType, 'rewardValue': rewardValue};
      },
    );
  }
}
