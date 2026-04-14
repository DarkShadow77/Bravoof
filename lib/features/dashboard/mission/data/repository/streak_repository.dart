import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/streak_response.dart';

abstract class StreakRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, StreakResponse>> fetchStreak();

  Future<Either<String, StreakResponse>> checkIn();
}
