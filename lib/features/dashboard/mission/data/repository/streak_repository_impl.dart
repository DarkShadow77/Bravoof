import 'package:dartz/dartz.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../../core/services/api_service.dart';
import '../model/streak_response.dart';
import 'streak_repository.dart';

class StreakRepositoryImpl extends StreakRepository {
  /// Fetch Streaks
  Future<Either<String, StreakResponse>> fetchStreak({
    required String userId,
  }) async {
    final String deviceTimezone = tz.local.name;
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'fetch-streak',
      body: {'timezone': deviceTimezone},
      fallbackErrorMessage: 'Failed to Fetch Streak',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }

  Future<Either<String, StreakResponse>> checkIn({
    required String userId,
  }) async {
    final String deviceTimezone = tz.local.name;
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'check-in',
      body: {'timezone': deviceTimezone},
      fallbackErrorMessage: 'Failed to Check In',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }
}
