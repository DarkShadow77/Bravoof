import 'package:dartz/dartz.dart';

import '../../../../../core/services/api_service.dart';
import '../model/response/recent_activity_model.dart';
import 'activity_repository.dart';

class RecentActivityRepositoryImpl extends RecentActivityRepository {
  @override
  Future<Either<String, RecentActivityPage>> fetchRecentActivity({
    required int page,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<RecentActivityPage>(
      functionName: 'fetch-recent-activity',
      queryParams: {'page': page.toString()},
      body: {},
      fallbackErrorMessage: 'Failed to fetch recent activity',
      onSuccess: (data) =>
          RecentActivityPage.fromJson(data['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<String, ActivityReactionResult>> reactToActivity({
    required int activityId,
    required String emoji,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<ActivityReactionResult>(
      functionName: 'react-to-activity',
      body: {'activityId': activityId, 'emoji': emoji},
      fallbackErrorMessage: 'Failed to update reaction',
      onSuccess: (data) =>
          ActivityReactionResult.fromJson(data['data'] as Map<String, dynamic>),
    );
  }
}
