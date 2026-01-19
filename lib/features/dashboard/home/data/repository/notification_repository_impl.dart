import 'package:dartz/dartz.dart';
import 'package:flowva/features/dashboard/home/data/model/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final supabase = Supabase.instance.client;

  /// Fetch active community mission
  Future<Either<String, List<NotificationModel>>> fetchNotifications() async {
    return ApiService.instance!.invokeEdgeFunction<List<NotificationModel>>(
      functionName: 'get-user-notifications',
      body: {'user_id': supabase.auth.currentUser!.id},
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

  Future<Either<String, String>> markAllNotificationAsRead() async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'mark-all-notifications-read',
      body: {'user_id': supabase.auth.currentUser!.id},
      fallbackErrorMessage: 'All Notification as Read failed',
      onSuccess: (data) => "Successfully Marked All Notification as Read",
    );
  }

  Future<Either<String, String>> clearNotification() async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'clear-user-notifications',
      body: {'user_id': supabase.auth.currentUser!.id},
      fallbackErrorMessage: 'Clear All Notification failed',
      onSuccess: (data) => "Successfully Cleared All Notification",
    );
  }
}
