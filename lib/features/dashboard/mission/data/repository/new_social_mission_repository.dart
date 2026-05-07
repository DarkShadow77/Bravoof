import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/mission_status_enum.dart';
import '../model/new_social_mission_model.dart';

abstract class NewSocialMissionRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<NewSocialMission>>> fetchNewSocialMission();

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
