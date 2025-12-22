import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/mission/data/model/quiz_response.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flowva/features/mission/data/model/skill_up_task_response.dart';
import 'package:flowva/features/mission/data/model/social_trivia_response.dart';
import 'package:flowva/features/mission/data/model/streak_response.dart';
import 'package:flowva/features/mission/data/model/trivia_response.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  // Future<void> fetchStreak() async {
  //   // final user = supabase.auth.currentUser;
  //   // if (user == null) return;
  //   //
  //
  //   final todayDate = DateTime.now().toUtc();
  //   final todayStr = todayDate.toIso8601String().split("T")[0];
  //
  //   // Get streak info
  //   final streakRes = await supabase
  //       .from('user_streaks')
  //       .select()
  //       .eq('user_id',sessionManager.userIdVal)
  //       .maybeSingle();
  //
  //   final profileRes = await supabase
  //       .from('user_profiles')
  //       .select('total_points')
  //       .eq('user_id', sessionManager.userIdVal)
  //       .maybeSingle();
  //
  //   if (profileRes != null) {
  //     final totalPoints = profileRes['total_points'] ?? 0;
  //
  //   }
  //
  //   if (streakRes != null) {
  //     final streakData = streakRes;
  //     final lastClaimed = streakData['last_claimed_date'];
  //
  //     final yesterday =
  //     todayDate.subtract(const Duration(days: 1)).toIso8601String().split("T")[0];
  //
  //     final shouldReset = lastClaimed != todayStr && lastClaimed != yesterday;
  //
  //     if (shouldReset) {
  //       await supabase
  //           .from('user_streaks')
  //           .update({'current_streak': 0, 'last_claimed_date': null})
  //           .eq('user_id', sessionManager.userIdVal);
  //     }
  //
  //   } else {
  //     await supabase.from('user_streaks').insert({
  //       'user_id':  sessionManager.userIdVal,
  //       'current_streak': 0,
  //       'last_claimed_date': null,
  //     });
  //
  //   }
  //
  // }

  Future<Either<String, RewardsSummaryResponse>> fetchAllUsersReward() async {
    try {
      final allUsersReward = await supabase
          .from('user_rewards_summary')
          .select(
            'total_point_redeemed, user_id, user_profile(name, profile_image, bio)',
          )
          .order('total_points', ascending: false); // Sort by points descending

      print(allUsersReward);

      if (allUsersReward != null) {
        RewardsSummaryResponse rewardsSummaryResponse =
            RewardsSummaryResponse.fromJson({"rewards": allUsersReward});

        return Right(rewardsSummaryResponse);
      } else {
        return Left("Empty");
      }
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

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

  Future<Either<String, StreakResponse>> claimStreakToday() async {
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

  Future<Either<String, MissionResponse>> fetchMission() async {
    try {
      final userId = sessionManager.userIdVal;

      final missionsRes = await supabase.from('mission').select();
      final completedRes = await supabase
          .from('mission_completed')
          .select()
          .eq('user_id', userId);

      // Create a map of mission_id -> completed
      final completedMap = {
        for (var item in completedRes) item['mission_id']: item['completed'],
      };

      MissionResponse missionResponse = MissionResponse.fromJson({
        "mission": missionsRes,
      });

      // Mark completed missions for this user
      missionResponse.mission = missionResponse.mission!.map((mission) {
        mission.completed = completedMap[mission.id] ?? false;
        return mission;
      }).toList();

      missionResponse.mission!.sort((a, b) => a.id!.compareTo(b.id!));

      return Right(missionResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, SocialTriviaResponse>> fetchSkillUpChallenge() async {
    try {
      var res = await supabase.from('skill_up_challenge').select();
      print("===============================");
      print(res);
      print("===============================");
      SocialTriviaResponse socialTriviaResponse = SocialTriviaResponse.fromJson(
        {"social": res},
      );
      return Right(socialTriviaResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> updateMission(
    Map<String, dynamic> mission,
  ) async {
    try {
      final userId = sessionManager.userIdVal;
      final email = sessionManager.userEmailval;

      final int pointsToAdd =
          int.tryParse(mission['points']?.toString() ?? '0') ?? 0;

      final int spinsToAdd =
          int.tryParse(mission['number_of_spins']?.toString() ?? '0') ?? 0;

      // 🔹 Upsert mission completion
      await supabase
          .from('mission_completed')
          .upsert(
            {
              "user_id": userId,
              "mission_id": mission['id'],
              "completed": true,
              "points": pointsToAdd,
              "name": mission['name'],
              "reward_title": mission['reward_title'],
              "number_of_spins": spinsToAdd,
              "updated_at": DateTime.now().toIso8601String(),
              "email": email,
            },
            onConflict: 'user_id, mission_id',
            ignoreDuplicates: false,
          );

      // 🔹 Fetch current totals
      final profileRes = await supabase
          .from('user_profile')
          .select('total_points, spins')
          .eq('user_id', userId)
          .maybeSingle();

      final int currentPoints = profileRes?['total_points'] ?? 0;
      final int currentSpins = profileRes?['spins'] ?? 0;

      final int newPoints = currentPoints + pointsToAdd;
      final int newSpins = currentSpins + spinsToAdd;

      // 🔹 Update BOTH points & spins
      await supabase
          .from('user_profile')
          .update({'total_points': newPoints, 'spins': newSpins})
          .eq('user_id', userId);

      return Right(AppBaseResponse(status: true));
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AppBaseResponse>> updateMissionLevel(
    Map<String, dynamic> mission,
  ) async {
    try {
      print(mission);
      var res = await supabase.from('claim_rewards').insert(mission);
      print(res);
      if (res == null) {
        // Update profile total points
        final profileRes = await supabase
            .from('user_profile')
            .select('total_points')
            .eq('user_id', mission['user_id'])
            .maybeSingle();
        print(profileRes);
        print(profileRes!['total_points']);
        print(mission['points']);
        int currentPoints = profileRes['total_points'] ?? 0;
        final newPoints = currentPoints + int.parse(mission['points']);

        var res = await supabase
            .from('user_profile')
            .update({'total_points': newPoints})
            .eq('user_id', mission['user_id']);

        final mis = await supabase
            .from('mission_level')
            .select('total_points')
            .eq('user_id', mission['user_id'])
            .maybeSingle();
        if (mis != null) {
          int prevPoints = mis['points'] ?? 0;
          final newPoints = prevPoints + int.parse(mission['points']);
          var res = await supabase
              .from('mission_level')
              .update({'points': newPoints})
              .eq('user_id', mission['user_id']);
          debugPrint("................$newPoints old point");
        } else {
          var res = await supabase.from('mission_level').insert(mission);
          debugPrint("................$newPoints new point");
        }
        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left("Something went wrong while updating your mission");
      }
    } on AuthException catch (e) {
      print(e);
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> saveAndUpdateSkillUp(
    Map<String, dynamic> mission,
  ) async {
    try {
      final fileName = DateTime.now().toIso8601String();
      print(fileName);
      await supabase.storage
          .from('skill_up_uploads')
          .upload(
            '$fileName',
            File(mission['image_url']),
            // fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabase.storage
          .from('skill_up_uploads')
          .getPublicUrl('$fileName');
      if (publicUrl.isNotEmpty) {
        mission['image_url'] = publicUrl;
        await supabase.from('skill_up_challenge').insert(mission);

        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left("Something went wrong while updating your mission");
      }
    } on AuthException catch (e) {
      print(e);
      return Left(e.message);
    }
  }

  Future<Either<String, QuizResponse>> fetchQuiz() async {
    try {
      final quiz = await supabase
          .from('quiz_question')
          .select('''
      question,
      correct_answer,
      id,
      quiz_answers (
        options
      )
    ''')
          .order('question', ascending: false);

      QuizResponse quizResponse = QuizResponse.fromJson({"quiz": quiz});
      return Right(quizResponse);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, QuizResponse>> fetchQuizCompleted() async {
    try {
      final quiz = await supabase
          .from('claim_rewards')
          .select()
          .eq('user_id', sessionManager.userIdVal)
          .eq('name', 'quiz')
          .single();

      print(quiz);
      QuizResponse quizResponse = QuizResponse.fromJson({"quiz": quiz});
      return Right(quizResponse);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SkillUpTaskResponse>> fetchSkillUPTask() async {
    try {
      final task = await supabase.from('skill_up_task').select("*");
      // print(quiz);
      SkillUpTaskResponse skillUpTaskResponse = SkillUpTaskResponse.fromJson({
        "task": task,
      });
      return Right(skillUpTaskResponse);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, TriviaResponse>> fetchTrivia() async {
    try {
      final response = await supabase.rpc('get_quiz_leaderboard_top50');
      print(response);
      TriviaResponse triviaResponse = TriviaResponse.fromJson({
        "trivia": response,
      });
      return Right(triviaResponse);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }
}
