import 'package:dartz/dartz.dart';
import 'package:Bravoo/features/dashboard/home/data/model/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<String, List<NotificationModel>>> fetchNotifications({
    required String userId,
  });
  Future<Either<String, String>> markNotificationAsRead({
    required int notificationId,
  });
  Future<Either<String, String>> markAllNotificationAsRead({
    required String userId,
  });
  Future<Either<String, String>> clearNotification({required String userId});
}
