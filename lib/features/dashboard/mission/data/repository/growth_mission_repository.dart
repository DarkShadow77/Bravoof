import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../earn/data/models/mission_res.dart';

abstract class GrowthMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<Mission>>> fetchGrowthMission();

  Future<Either<String, void>> completeMission({
    required Map<String, dynamic> mission,
  });
}
