import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../session/session_manager.dart';
import '../model/streak_response.dart';
import 'streak_repository.dart';

class StreakRepositoryImpl extends StreakRepository {
  final supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  /// Fetch Streaks
  Future<Either<String, StreakResponse>> fetchStreak() async {
    try {
      final userId = sessionManager.userIdVal;

      final res = await supabase
          .from('user_streaks')
          .select('id, current_streak, last_claimed_date, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      if (res.isEmpty) {
        // Return empty streak instead of error
        return Right(
          StreakResponse(
            id: 0,
            userId: userId,
            currentStreak: 0,
            history: const [],
          ),
        );
      }

      // 🔹 History (every real check-in)
      final history = res
          .where((e) => e['last_claimed_date'] != null)
          .map<DateTime>((e) {
            final d = DateTime.parse(e['last_claimed_date']);
            return DateTime(d.year, d.month, d.day); // normalize
          })
          .toList();

      // 🔹 Latest row = current streak state
      final latest = res.last;

      final summary = StreakResponse(
        id: latest['id'],
        userId: userId,
        currentStreak: latest['current_streak'] ?? 0,
        lastClaimedDate: latest['last_claimed_date'] != null
            ? DateTime.parse(latest['last_claimed_date'])
            : null,
        history: history,
      );

      return Right(summary);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, StreakResponse>> checkIn() async {
    try {
      final userId = sessionManager.userIdVal;

      // 🔹 Local date (NOT UTC)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      // Fetch latest streak for today logic
      final streakRes = await supabase
          .from('user_streaks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      int newStreak = 1;
      int streakId;

      if (streakRes.isEmpty) {
        // First-ever check-in
        final insertedStreak = await supabase
            .from('user_streaks')
            .insert({
              'user_id': userId,
              'current_streak': 1,
              'last_claimed_date': today.toIso8601String(),
            })
            .select()
            .single();
        streakId = insertedStreak['id'];
        newStreak = 1;
      } else {
        final lastClaimed = DateTime.parse(streakRes.last['last_claimed_date']);
        final lastDate = DateTime(
          lastClaimed.year,
          lastClaimed.month,
          lastClaimed.day,
        );

        if (lastDate == today) {
          return Left("You have already checked in today");
        }

        if (lastDate == yesterday) {
          newStreak = (streakRes.last['current_streak'] ?? 0) + 1;
        } else {
          // ❌ Missed a day → reset streak
          newStreak = 1;
        }

        final insertedStreak = await supabase
            .from('user_streaks')
            .insert({
              'user_id': userId,
              'current_streak': newStreak,
              'last_claimed_date': today.toIso8601String(),
            })
            .select()
            .single();
        streakId = insertedStreak['id'];
      }

      // 🔹 Reward logic
      const int pointsToAdd = 5;

      final profile = await supabase
          .from('user_profile')
          .select('total_points')
          .eq('user_id', userId)
          .single();

      final updatedPoints = (profile['total_points'] ?? 0) + pointsToAdd;

      await supabase
          .from('user_profile')
          .update({'total_points': updatedPoints})
          .eq('user_id', userId);

      // 🔹 Logs
      await supabase.from('user_rewards_summary').insert({
        'user_id': userId,
        'email': sessionManager.userEmailval,
        'name': 'streak',
        'total_points': pointsToAdd,
        'total_claim_reward': pointsToAdd,
        'total_point_redeemed': updatedPoints,
      });

      await supabase.from('claim_rewards').insert({
        "name": "Streak",
        "reward_title": "Daily check-in",
        "points": pointsToAdd,
        "user_id": userId,
        "email": sessionManager.userEmailval,
      });

      // 🔹 Build history from all streak rows
      final history = streakRes.map<DateTime>((e) {
        final d = DateTime.parse(e['last_claimed_date']);
        return DateTime(d.year, d.month, d.day); // normalize
      }).toList()..add(today);

      return Right(
        StreakResponse(
          id: streakId,
          userId: userId,
          currentStreak: newStreak,
          lastClaimedDate: today,
          history: history,
        ),
      );
    } catch (e) {
      log("Check In Error: ${e.toString()}");
      return Left(e.toString());
    }
  }
}
