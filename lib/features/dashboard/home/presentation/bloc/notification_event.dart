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

class FetchNotificationPreferences extends NotificationEvent {
  FetchNotificationPreferences();
}

class SaveNotificationPreferences extends NotificationEvent {
  final bool rewardsEnabled;
  final bool offersEnabled;
  SaveNotificationPreferences({
    required this.rewardsEnabled,
    required this.offersEnabled,
  });
}
