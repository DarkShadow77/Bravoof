part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  LoadNotifications();
}

class MarkNotificationRead extends NotificationEvent {
  final int notificationId;
  MarkNotificationRead({required this.notificationId});
}

class MarkAllNotificationRead extends NotificationEvent {
  MarkAllNotificationRead();
}

class ClearNotification extends NotificationEvent {
  ClearNotification();
}
