import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_mission_model.dart';
import '../models/community_mission_status_enum.dart';
import 'community_mission_repository.dart';

class CommunityMissionRepositoryImpl extends CommunityMissionRepository {
  final supabase = Supabase.instance.client;

  /// Fetch active community mission
  Future<Either<String, CommunityMission>> fetchActiveMission() async {
    try {
      final res = await supabase
          .from('community_missions')
          .select()
          .eq('status', true)
          .order('created_at', ascending: true);

      log("Community Missions $res");
      if (res.isEmpty) {
        return Left('No active community mission found');
      }

      // 🔹 Pick the last mission after ascending sort
      final latestMission = res.last;

      return Right(CommunityMission.fromJson(latestMission));
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Join / Update mission
  Future<Either<String, void>> joinMission({
    required int missionId,
    required String userId,
    required String email,
    required String? imageUrl,
  }) async {
    try {
      // Check if user already joined
      final existing = await supabase
          .from('community_mission_completed')
          .select('id')
          .eq('community_mission_id', missionId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        // First join
        await supabase.from('community_mission_completed').insert({
          'community_mission_id': missionId,
          'user_id': userId,
          'email': email,
          'evidence_image': imageUrl,
          'status': 'PENDING',
        });

        // Increment joined users
        await supabase.rpc(
          'increment_community_users',
          params: {'mission_id': missionId},
        );
      } else {
        // Update existing submission
        await supabase
            .from('community_mission_completed')
            .update({
              'email': email,
              'evidence_image': imageUrl,
              'status': 'PENDING',
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      }
    } catch (e) {
      return Left(e.toString());
    }

    return const Right(null);
  }

  /// Check if user already joined
  Future<CommunityMissionStatus> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    final res = await supabase
        .from('community_mission_completed')
        .select('status')
        .eq('community_mission_id', missionId)
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) {
      return CommunityMissionStatus.notJoined;
    }

    return statusFromDb(res['status'] as String);
  }
}
