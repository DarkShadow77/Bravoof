import 'package:bravoo/features/dashboard/home/data/model/notification_model.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<String, List<NotificationModel>>> fetchNotifications();
  Future<Either<String, String>> markNotificationAsRead({
    required int notificationId,
  });
  Future<Either<String, String>> markAllNotificationAsRead();
  Future<Either<String, String>> clearNotification();

  Future<Either<String, Map<String, dynamic>>> fetchNotificationPreferences();

  Future<Either<String, String>> saveNotificationPreferences({
    required bool rewardsEnabled,
    required bool offersEnabled,
  });
}
