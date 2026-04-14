import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../../../core/services/api_service.dart';
import '../model/streak_response.dart';
import 'streak_repository.dart';

Future<String> getTimeZone() async {
  String deviceTimezone;

  try {
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    deviceTimezone = timezoneInfo.identifier;

    debugPrint('FlutterTimezone SUCCESS: $deviceTimezone');
  } catch (e) {
    debugPrint('FlutterTimezone ERROR: $e');
    deviceTimezone = 'UTC';
  }

  if (deviceTimezone.isEmpty) {
    deviceTimezone = 'UTC';
  }

  return deviceTimezone;
}

class StreakRepositoryImpl extends StreakRepository {
  /// Fetch Streaks
  Future<Either<String, StreakResponse>> fetchStreak() async {
    final String deviceTimezone = await getTimeZone();
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'fetch-streak',
      body: {'timezone': deviceTimezone},
      fallbackErrorMessage: 'Failed to Fetch Streak',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }

  Future<Either<String, StreakResponse>> checkIn() async {
    final String deviceTimezone = await getTimeZone();
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'check-in',
      body: {'timezone': deviceTimezone},
      fallbackErrorMessage: 'Failed to Check In',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }
}
