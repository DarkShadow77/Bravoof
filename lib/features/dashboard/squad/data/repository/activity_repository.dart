import 'package:dartz/dartz.dart';

import '../model/response/recent_activity_model.dart';

abstract class RecentActivityRepository {
  Future<Either<String, RecentActivityPage>> fetchRecentActivity({
    required int page,
  });

  Future<Either<String, ActivityReactionResult>> reactToActivity({
    required int activityId,
    required String emoji,
  });
}
