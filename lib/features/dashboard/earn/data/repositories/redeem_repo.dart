import 'dart:async';
import 'dart:convert';

import 'package:Bravoo/session/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// 2️⃣ Build the Edge Function URL
final supabaseUrl = String.fromEnvironment(
  'https://urdebuxbzqiwqgyzrrmy.supabase.co',
  defaultValue: 'https://urdebuxbzqiwqgyzrrmy.supabase.co',
);

class RedeemRepo {
  final supabase = Supabase.instance.client;
  final sessionManager = SessionManager();

  // let referralHandled = false;
  handleReferralInsertOnly() async {
    // if (referralHandled) return;
    // referralHandled = true;

    final session = await supabase.auth.currentSession;

    final user = session?.user;
    final token = session?.accessToken;
    // final metadata = user?.user_metadata;

    const referralCode = 0;

    if (referralCode == null) return;

    await http.post(
      Uri.parse("/functions/v1/add_referral"),

      headers: {
        "Content-Type": "application/json",
        'apikey':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVyZGVidXhienFpd3FneXpycm15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDgzMzEsImV4cCI6MjA3NjAyNDMzMX0.sX0a4xtEfHAHeSSCReY-9JUGrHxZwYLe0nYKsbTdRpE",
        'Authorization': '$token',
      },
      body: {'referred_user_id': user!.id, 'referral_code': referralCode},
    );
  }

  Future<Map<String, dynamic>> claimReward({
    required String rewardTitle,
    required int rewardPoints,
    required String userEmail,
    required String name,
    String? address,
    String? phone,
    String? zipCode,
  }) async {
    try {
      // 1️⃣ Get current authenticated user
      final userResponse = await supabase.auth.getUser();
      final user = userResponse.user;
      final userId = user?.id;

      if (userId == null) {
        return {'success': false, 'message': 'User not authenticated'};
      }

      // 2️⃣ Fetch user's current total_points
      final profileResponse = await supabase
          .from('user_profiles')
          .select('total_points')
          .eq('user_id', userId)
          .maybeSingle(); // prevents "Cannot coerce result" error

      if (profileResponse == null) {
        return {
          'success': false,
          'message': 'Failed to fetch user profile data',
        };
      }

      final currentPoints = profileResponse['total_points'] ?? 0;

      // 3️⃣ Check if user has enough points
      if (currentPoints < rewardPoints) {
        return {
          'success': false,
          'message': 'Insufficient points to claim reward',
        };
      }

      final newTotalPoints = currentPoints - rewardPoints;

      // 4️⃣ Update user's total_points
      final updateResponse = await supabase
          .from('user_profiles')
          .update({'total_points': newTotalPoints})
          .eq('user_id', userId);

      if (updateResponse.error != null) {
        print('Update error: ${updateResponse.error!.message}');
        return {'success': false, 'message': 'Failed to update user points'};
      }

      // 5️⃣ Record the reward claim
      final insertResponse = await supabase.from('claimed_rewards').insert({
        'user_id': userId,
        'reward_title': rewardTitle,
        'email': userEmail,
        'name': name,
        'points': rewardPoints,
      });

      if (insertResponse.error != null) {
        print(
          'Insert error: ${insertResponse.error!.message} | ${insertResponse.error!.details}',
        );
        return {
          'success': false,
          'message': insertResponse.error!.message,
          'details': insertResponse.error!.details,
        };
      }

      return {'success': true, 'message': 'Reward successfully claimed'};
    } catch (e) {
      print('Unexpected error: $e');
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>?> handleDailyClaim({
    required String source, // "try", "share", "review", or "tow"
    String? userIdOverride,
  }) async {
    try {
      final url = Uri.parse('$supabaseUrl/functions/v1/earn-more-points');
      // 1️⃣ Get the current Supabase session
      final sessionResponse = await supabase.auth.currentSession;
      final session = sessionResponse;
      print(sessionResponse);
      final token = session?.accessToken;
      final userId = userIdOverride ?? session?.user.id;

      if (userId == null || token == null) {
        print('⚠️ User not authenticated');
        return {'status': 401, 'error': 'User not authenticated'};
      }

      // 3️⃣ Prepare the request payload
      final body = jsonEncode({'user_id': userId, 'source': source});

      // 4️⃣ Send POST request with Bearer token
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      // 5️⃣ Parse the response
      final Map<String, dynamic>? jsonResponse = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      return {'status': response.statusCode, 'error': jsonResponse?['error']};
    } catch (e) {
      print('❌ handleDailyClaim error: $e');
      return {'status': 500, 'error': e.toString()};
    }
  }
}
