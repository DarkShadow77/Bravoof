import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/mission_status_enum.dart';
import '../models/social_mission_model.dart';

abstract class SocialMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<SocialMission>>> fetchSocialMission();

  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String? text,
    required String? imageUrl,
  });

  Future<MissionStatus> hasJoined({
    required int missionId,
    required String userId,
  });
}
