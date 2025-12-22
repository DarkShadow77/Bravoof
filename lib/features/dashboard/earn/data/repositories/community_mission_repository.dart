import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_mission_model.dart';
import '../models/community_mission_status_enum.dart';

abstract class CommunityMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, CommunityMission>> fetchActiveMission();

  Future<Either<String, void>> joinMission({
    required int missionId,
    required String userId,
    required String email,
    required String? imageUrl,
  });

  Future<CommunityMissionStatus> hasJoined({
    required int missionId,
    required String userId,
  });
}
