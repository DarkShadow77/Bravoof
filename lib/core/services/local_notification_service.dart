import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:get_it/get_it.dart';

import '../../features/dashboard/home/presentation/bloc/notification_bloc.dart';

class LocalNotificationService {
  LocalNotificationService._internal();

  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final _androidInitializationSettings = const AndroidInitializationSettings(
    'ic_notification',
  );

  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final _androidChannel = const AndroidNotificationChannel(
    'channel_id',
    'Channel name',
    description: 'Android push notification channel',
    importance: Importance.max,
    showBadge: true,
  );

  bool _isFlutterLocalNotificationInitialized = false;
  int _notificationIdCounter = 0;

  Future<void> init() async {
    if (_isFlutterLocalNotificationInitialized) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Foreground notification tapped: ${response.payload}');
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    _isFlutterLocalNotificationInitialized = true;
  }

  // ─── Get unread count from NotificationBloc ──────────────────────
  int _getUnreadCount() {
    try {
      final notificationBloc = GetIt.instance<NotificationBloc>();
      return notificationBloc.state.unreadCount;
    } catch (e) {
      debugPrint('Could not get NotificationBloc: $e');
      return 0;
    }
  }

  // ─── Sync app icon badge with current unread count ───────────────
  Future<void> updateBadge() async {
    final unreadCount = _getUnreadCount();
    await _setBadge(unreadCount);
  }

  Future<void> checkBadgeSupport() async {
    try {
      await FlutterNewBadger.setBadge(5);
      final badge = await FlutterNewBadger.getBadge();
      debugPrint('Badge support test — current badge: $badge');
    } catch (e) {
      debugPrint('Badge not supported on this device/launcher: $e');
    }
  }

  Future<void> _setBadge(int count) async {
    try {
      if (count <= 0) {
        await FlutterNewBadger.removeBadge();
        debugPrint('App badge removed');
      } else {
        await FlutterNewBadger.setBadge(count);
        debugPrint('App badge set to: $count');
      }
    } catch (e) {
      debugPrint('Failed to update app badge: $e');
    }
  }

  // ─── Clear badge (call when user opens notifications screen) ─────
  Future<void> clearBadge() async {
    try {
      await FlutterNewBadger.removeBadge();
      debugPrint('App badge cleared');
    } catch (e) {
      debugPrint('Failed to clear badge: $e');
    }
  }

  // ─── Show a local notification ────────────────────────────────────
  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    // +1 because this new notification hasn't hit the bloc yet
    final badgeCount = _getUnreadCount() + 1;

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
      number: badgeCount,
      showWhen: true,
    );

    final iosDetails = DarwinNotificationDetails(badgeNumber: badgeCount);

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    // Also update the app icon badge directly
    await _setBadge(badgeCount);
  }
}
