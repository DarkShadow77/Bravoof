import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../../session/session_manager.dart';
import '../model/streak_response.dart';
import 'streak_repository.dart';

class StreakRepositoryImpl extends StreakRepository {
  final supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  /// Fetch Streaks
  Future<Either<String, StreakResponse>> fetchStreak({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'fetch-streak',
      body: {'userId': userId},
      fallbackErrorMessage: 'Failed to Fetch Streak',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }

  Future<Either<String, StreakResponse>> checkIn({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<StreakResponse>(
      functionName: 'check-in',
      body: {'userId': userId},
      fallbackErrorMessage: 'Failed to CheckIn',
      onSuccess: (data) => StreakResponse.fromJson(data['data']),
    );
  }
}
