import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  //Private constructor for singleton pattern
  LocalNotificationService._internal();

  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final _androidInitializationSettings = const AndroidInitializationSettings(
    "ic_notification",
  );

  //IOS-specific initialization settings with permission requests
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  //Android notification channel configuration
  final _androidChannel = const AndroidNotificationChannel(
    "channel_id",
    "Channel name",
    description: "Android push notification channel",
    importance: Importance.max,
  );

  //Flag to track initialization Status
  bool _isFlutterLocalNotificationInitialized = false;

  //Counter for generating unique notification IDs
  int _notificationIdCounter = 0;

  //Initialize the local notification plugin for Android and IOS
  Future<void> init() async {
    //Check if already initialized to prevent redundant setup
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    //Create plugin instance
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //Combine platform-specific settings
    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );

    //initialize plugin with settings and callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint(
          "Foreground notification has been tapped: ${response.payload}",
        );
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    //Create Android Notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    //Mark initialization as complete
    _isFlutterLocalNotificationInitialized = true;
  }

  Future<int> _incrementBadgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('badge_count') ?? 0;
    final updated = current + 1;
    await prefs.setInt('badge_count', updated);
    return updated;
  }

  Future<void> clearBadge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('badge_count', 0);

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  //Show a local notification with the given title, body, and payload
  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    final badgeCount = await _incrementBadgeCount();

    //Android-specific notification details
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    //IOS-specific notification details
    final iosDetails = DarwinNotificationDetails(badgeNumber: badgeCount);

    //Combine platform-specific details
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    //Display the notification
    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
