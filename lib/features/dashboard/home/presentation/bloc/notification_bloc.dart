import 'package:bloc/bloc.dart';
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
    : super(NotificationInitialState(notification: [])) {
    on<LoadNotifications>(_loadNotifications);
    on<MarkNotificationRead>(_markNotificationRead);
    on<MarkAllNotificationRead>(_markAllNotificationRead);
    on<ClearNotification>(_clearAllNotification);
  }

  Future<void> _loadNotifications(LoadNotifications event, Emitter emit) async {
    emit(
      NotificationLoading(
        type: NotificationType.fetchNotification,
        notification: state.notification,
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
        ),
      ),
      (notification) {
        emit(state.copyWith(notification: notification));
        emit(
          NotificationSuccessState(
            type: NotificationType.fetchNotification,
            message: "Successfully Fetched Notifications",
            notification: state.notification,
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
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.markNotificationAsRead,
            message: success,
            notification: state.notification,
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
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.markAllNotificationAsRead,
            message: success,
            notification: state.notification,
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
        ),
      ),
      (success) {
        add(LoadNotifications());
        emit(
          NotificationSuccessState(
            type: NotificationType.clearNotification,
            message: success,
            notification: state.notification,
          ),
        );
      },
    );
  }
}
