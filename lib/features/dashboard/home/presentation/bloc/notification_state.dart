part of 'notification_bloc.dart';

enum NotificationType {
  fetchNotification,
  markNotificationAsRead,
  markAllNotificationAsRead,
  clearNotification,
}

@immutable
class NotificationState {
  final List<NotificationModel> notification;

  NotificationState({required this.notification});

  NotificationState copyWith({List<NotificationModel>? notification}) {
    return NotificationState(notification: notification ?? this.notification);
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState({required super.notification});
}

class NotificationLoading extends NotificationState {
  final NotificationType type;
  NotificationLoading({required this.type, required super.notification});
}

class NotificationErrorState extends NotificationState {
  final String message;
  final NotificationType type;
  NotificationErrorState({
    required this.message,
    required this.type,
    required super.notification,
  });
}

class NotificationSuccessState extends NotificationState {
  final String message;
  final NotificationType type;
  NotificationSuccessState({
    required this.message,
    required this.type,
    required super.notification,
  });
}
