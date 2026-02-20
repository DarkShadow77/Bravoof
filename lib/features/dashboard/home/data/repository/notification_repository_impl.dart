import 'package:bravoo/features/dashboard/home/data/model/notification_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<NotificationModel>>> fetchNotifications({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<NotificationModel>>(
      functionName: 'get-user-notifications',
      body: {'user_id': userId},
      fallbackErrorMessage: 'Failed to Retrieve Notifications',
      onSuccess: (data) {
        final notification = data["data"] as List;
        return notification.map((e) => NotificationModel.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> markNotificationAsRead({
    required int notificationId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'mark-notification-read',
      body: {'notification_id': notificationId},
      fallbackErrorMessage: 'Notification as Read failed',
      onSuccess: (data) => "Successfully Marked Notification as Read",
    );
  }

  Future<Either<String, String>> markAllNotificationAsRead({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'mark-all-notifications-read',
      body: {'user_id': userId},
      fallbackErrorMessage: 'All Notification as Read failed',
      onSuccess: (data) => "Successfully Marked All Notification as Read",
    );
  }

  Future<Either<String, String>> clearNotification({
    required String userId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'clear-user-notifications',
      body: {'user_id': userId},
      fallbackErrorMessage: 'Clear All Notification failed',
      onSuccess: (data) => "Successfully Cleared All Notification",
    );
  }

  Future<Either<String, Map<String, dynamic>>>
  fetchNotificationPreferences() async {
    return ApiService.instance!.invokeEdgeFunction<Map<String, dynamic>>(
      functionName: 'fetch-notification-preferences',
      body: {},
      fallbackErrorMessage: 'Failed to Fetched Notification Preferences',
      onSuccess: (data) {
        return data["data"];
      },
    );
  }

  Future<Either<String, String>> saveNotificationPreferences({
    required bool rewardsEnabled,
    required bool offersEnabled,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'save-notification-preferences',
      body: {'rewardsEnabled': rewardsEnabled, 'offersEnabled': offersEnabled},
      fallbackErrorMessage: 'Failed to Save Notification Preferences',
      onSuccess: (data) => "Successfully Save Notification Preferences",
    );
  }
}
