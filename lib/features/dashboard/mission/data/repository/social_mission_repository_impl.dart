import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/mission_status_enum.dart';
import '../model/social_mission_model.dart';
import 'social_mission_repository.dart';

class SocialMissionRepositoryImpl extends SocialMissionRepository {
  final supabase = Supabase.instance.client;

  /// Fetch social mission
  Future<Either<String, List<SocialMission>>> fetchSocialMission() async {
    try {
      final res = await supabase
          .from('social_missions')
          .select()
          .order('id', ascending: true);

      if (res.isEmpty) {
        return Left('No social mission found');
      }

      return Right(res.map((e) => SocialMission.fromJson(e)).toList());
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
          .from('social_mission_completed')
          .select('id')
          .eq('social_mission_id', missionId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        // First join
        await supabase.from('social_mission_completed').insert({
          'social_mission_id': missionId,
          'user_id': userId,
          'answer': text,
          'evidence_image': imageUrl,
          'status': 'PENDING',
        });
      } else {
        // Update existing submission
        await supabase
            .from('social_mission_completed')
            .update({
              'answer': text,
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
        .from('social_mission_completed')
        .select('status')
        .eq('social_mission_id', missionId)
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) {
      return MissionStatus.notJoined;
    }

    return statusFromDb(res['status'] as String);
  }
}
