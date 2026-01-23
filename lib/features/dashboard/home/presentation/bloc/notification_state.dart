part of 'notification_bloc.dart';

enum NotificationType {
  fetchNotification,
  markNotificationAsRead,
  markAllNotificationAsRead,
  clearNotification,
  fetchNotificationPreferences,
  saveNotificationPreferences,
}

@immutable
class NotificationState {
  final List<NotificationModel> notification;
  final bool rewardEnabled;
  final bool offerEnabled;

  NotificationState({
    required this.notification,
    required this.rewardEnabled,
    required this.offerEnabled,
  });

  NotificationState copyWith({
    List<NotificationModel>? notification,
    bool? rewardEnabled,
    bool? offerEnabled,
  }) {
    return NotificationState(
      notification: notification ?? this.notification,
      rewardEnabled: rewardEnabled ?? this.rewardEnabled,
      offerEnabled: offerEnabled ?? this.offerEnabled,
    );
  }
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState({
    required super.notification,
    required super.rewardEnabled,
    required super.offerEnabled,
  });
}

class NotificationLoading extends NotificationState {
  final NotificationType type;
  NotificationLoading({
    required this.type,
    required super.notification,
    required super.rewardEnabled,
    required super.offerEnabled,
  });
}

class NotificationErrorState extends NotificationState {
  final String message;
  final NotificationType type;
  NotificationErrorState({
    required this.message,
    required this.type,
    required super.notification,
    required super.rewardEnabled,
    required super.offerEnabled,
  });
}

class NotificationSuccessState extends NotificationState {
  final String message;
  final NotificationType type;
  NotificationSuccessState({
    required this.message,
    required this.type,
    required super.notification,
    required super.rewardEnabled,
    required super.offerEnabled,
  });
}
