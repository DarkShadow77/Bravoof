import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/notification_model.dart';
import '../../data/repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repo;
  final supabase = Supabase.instance.client;
  NotificationBloc({required this.repo})
    : super(
        NotificationInitialState(
          notification: [],
          rewardEnabled: true,
          offerEnabled: true,
        ),
      ) {
    on<LoadNotifications>(_loadNotifications);
    on<MarkNotificationRead>(_markNotificationRead);
    on<MarkAllNotificationRead>(_markAllNotificationRead);
    on<ClearNotification>(_clearAllNotification);
    on<FetchNotificationPreferences>(_fetchNotificationPreferences);
    on<SaveNotificationPreferences>(_saveNotificationPreferences);
  }

  Future<void> _loadNotifications(LoadNotifications event, Emitter emit) async {
    emit(
      NotificationLoading(
        type: NotificationType.fetchNotification,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final notificationRes = await repo.fetchNotifications(
      userId: supabase.auth.currentUser!.id,
    );

    notificationRes.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.fetchNotification,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
      (notification) {
        emit(state.copyWith(notification: notification));
        emit(
          NotificationSuccessState(
            type: NotificationType.fetchNotification,
            message: "Successfully Fetched Notifications",
            notification: state.notification,
            rewardEnabled: state.rewardEnabled,
            offerEnabled: state.offerEnabled,
          ),
        );
      },
    );
  }

  Future<void> _markNotificationRead(
    MarkNotificationRead event,
    Emitter emit,
  ) async {
    emit(
      NotificationLoading(
        type: NotificationType.markNotificationAsRead,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final res = await repo.markNotificationAsRead(
      notificationId: event.notificationId,
    );

    res.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.markNotificationAsRead,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.markNotificationAsRead,
            message: success,
            notification: state.notification,
            rewardEnabled: state.rewardEnabled,
            offerEnabled: state.offerEnabled,
          ),
        );
      },
    );
  }

  Future<void> _markAllNotificationRead(
    MarkAllNotificationRead event,
    Emitter emit,
  ) async {
    emit(
      NotificationLoading(
        type: NotificationType.markAllNotificationAsRead,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final res = await repo.markAllNotificationAsRead(
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.markAllNotificationAsRead,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.markAllNotificationAsRead,
            message: success,
            notification: state.notification,
            rewardEnabled: state.rewardEnabled,
            offerEnabled: state.offerEnabled,
          ),
        );
      },
    );
  }

  Future<void> _clearAllNotification(
    ClearNotification event,
    Emitter emit,
  ) async {
    emit(
      NotificationLoading(
        type: NotificationType.clearNotification,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final res = await repo.clearNotification(
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.clearNotification,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.clearNotification,
            message: success,
            notification: state.notification,
            rewardEnabled: state.rewardEnabled,
            offerEnabled: state.offerEnabled,
          ),
        );
      },
    );
  }

  Future<void> _fetchNotificationPreferences(
    FetchNotificationPreferences event,
    Emitter emit,
  ) async {
    emit(
      NotificationLoading(
        type: NotificationType.fetchNotificationPreferences,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final res = await repo.fetchNotificationPreferences();

    res.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.fetchNotificationPreferences,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
      (preferences) {
        Logger().d("Preferences $preferences ${preferences.runtimeType}");
        emit(
          state.copyWith(
            rewardEnabled: preferences["rewards"] ?? true,
            offerEnabled: preferences["offers"] ?? true,
          ),
        );
        emit(
          NotificationSuccessState(
            type: NotificationType.fetchNotificationPreferences,
            message: "Successfully Fetched Notification Preferences",
            notification: state.notification,
            rewardEnabled: preferences["rewards"] ?? true,
            offerEnabled: preferences["offers"] ?? true,
          ),
        );
      },
    );
  }

  Future<void> _saveNotificationPreferences(
    SaveNotificationPreferences event,
    Emitter emit,
  ) async {
    emit(
      NotificationLoading(
        type: NotificationType.saveNotificationPreferences,
        notification: state.notification,
        rewardEnabled: state.rewardEnabled,
        offerEnabled: state.offerEnabled,
      ),
    );

    final res = await repo.saveNotificationPreferences(
      rewardsEnabled: event.rewardsEnabled,
      offersEnabled: event.offersEnabled,
    );

    res.fold(
      (err) => emit(
        NotificationErrorState(
          type: NotificationType.saveNotificationPreferences,
          message: err,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),

      (success) => emit(
        NotificationSuccessState(
          type: NotificationType.saveNotificationPreferences,
          message: success,
          notification: state.notification,
          rewardEnabled: state.rewardEnabled,
          offerEnabled: state.offerEnabled,
        ),
      ),
    );
  }
}
