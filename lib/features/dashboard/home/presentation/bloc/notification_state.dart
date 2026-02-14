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
  final int unreadCount;

  NotificationState({
    required this.notification,
    required this.rewardEnabled,
    required this.offerEnabled,
    this.unreadCount = 0,
  });

  // Computed from the notification list directly
  int get computedUnreadCount => notification.where((n) => !n.read).length;

  NotificationState copyWith({
    List<NotificationModel>? notification,
    bool? rewardEnabled,
    bool? offerEnabled,
    int? unreadCount,
  }) {
    final updatedNotifications = notification ?? this.notification;
    return NotificationState(
      notification: notification ?? this.notification,
      rewardEnabled: rewardEnabled ?? this.rewardEnabled,
      offerEnabled: offerEnabled ?? this.offerEnabled,
      // Always recompute from list when notifications change
      unreadCount: notification != null
          ? updatedNotifications.where((n) => !n.read).length
          : unreadCount ?? this.unreadCount,
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
