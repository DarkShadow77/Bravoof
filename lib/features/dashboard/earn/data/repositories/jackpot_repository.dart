import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class JackpotRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, Map<String, dynamic>>> spinJackpot({
    required String userId,
  });
}
