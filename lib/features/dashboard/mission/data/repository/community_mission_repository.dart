import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/community_mission_model.dart';
import '../model/mission_status_enum.dart';

abstract class CommunityMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, CommunityMission>> fetchActiveMission();

  Future<Either<String, void>> joinMission({
    required int missionId,
    required String userId,
    required String? imageUrl,
  });

  Future<MissionStatus> hasJoined({
    required int missionId,
    required String userId,
  });
}
