import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/featured_mission_model.dart';
import '../models/mission_status_enum.dart';
import 'featured_mission_repository.dart';

class FeaturedMissionRepositoryImpl extends FeaturedMissionRepository {
  final supabase = Supabase.instance.client;

  /// Fetch featured mission
  Future<Either<String, List<FeaturedMission>>> fetchFeaturedMission() async {
    try {
      final res = await supabase.from('featured_missions').select();

      log("Featured Missions $res");
      if (res.isEmpty) {
        return Left('No featured mission found');
      }

      return Right(res.map((e) => FeaturedMission.fromJson(e)).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Join / Update mission
  Future<Either<String, void>> completeMission({
    required int missionId,
    required String userId,
    required String? text,
    required String? imageUrl,
  }) async {
    try {
      // Check if user already joined
      final existing = await supabase
          .from('featured_mission_completed')
          .select('id')
          .eq('featured_mission_id', missionId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        // First join
        await supabase.from('featured_mission_completed').insert({
          'featured_mission_id': missionId,
          'user_id': userId,
          // 'answer': text,
          'evidence_image': imageUrl,
          'status': 'PENDING',
        });
      } else {
        // Update existing submission
        await supabase
            .from('featured_mission_completed')
            .update({
              // 'answer': text,
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
  Future<MissionStatus> hasJoined({
    required int missionId,
    required String userId,
  }) async {
    final res = await supabase
        .from('featured_mission_completed')
        .select('status')
        .eq('featured_mission_id', missionId)
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) {
      return MissionStatus.notJoined;
    }

    return statusFromDb(res['status'] as String);
  }
}
