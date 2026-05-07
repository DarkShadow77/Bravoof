import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/community_mission_model.dart';
import '../model/mission_status_enum.dart';

abstract class CommunityMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, CommunityMission>> fetchCommunityMission();

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String? image,
    required String? text,
    required bool isVideo,
  });

  Future<Either<String, MissionStatus>> hasJoined({
    required int missionId,
    required String userId,
  });
}
