import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/mission_status_enum.dart';
import '../model/sponsored_mission_model.dart';

abstract class SponsoredMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<SponsoredMission>>> fetchSponsoredMission();

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
