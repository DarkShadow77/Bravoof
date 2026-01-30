import 'dart:io';

import 'package:Bravoo/core/services/local_notification_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseMessagingService {
  //Private constructor for singleton patterm
  FirebaseMessagingService._internal();

  //Singleton Instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  //Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  //Reference to local notification service for displaying notifications
  LocalNotificationService? _localNotificationService;

  //Instance Firebase Messaging and sets up all message listeners
  Future<void> init({
    required LocalNotificationService localNotificationService,
  }) async {
    //init local notification service
    _localNotificationService = localNotificationService;

    //Handle FCM token
    _handlePushNotificationToken();

    //Request user permission for notifications
    _requestPermission();

    //Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //Listen for messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    debugPrint("App Version: $info");
    return '${info.version}+${info.buildNumber}';
  }

  Future<String?> getFcmToken() async {
    try {
      // Android 13+ requires explicit permission
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission();

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint("❌ Push notification permission not granted");
        return null;
      }

      // Small delay helps avoid SERVICE_NOT_AVAILABLE on cold start
      await Future.delayed(const Duration(seconds: 1));

      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("✅ Push notifications token: $token");

      return token;
    } catch (e) {
      debugPrint("⚠️ Failed to get FCM token: $e");
      return null;
    }
  }

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    // Reuse stored ID if exists
    final existing = prefs.getString('device_id');
    if (existing != null) return existing;

    final deviceInfo = DeviceInfoPlugin();
    String rawId;

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      rawId = android.id; // NOT guaranteed unique, used only as entropy
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      rawId = ios.identifierForVendor ?? '';
    } else {
      rawId = '';
    }

    final uuid = const Uuid().v5(
      Uuid.NAMESPACE_URL,
      '$rawId-${DateTime.now().millisecondsSinceEpoch}',
    );

    await prefs.setString('device_id', uuid);
    return uuid;
  }

  //Retrieve and manage the FCM token for push notifications
  Future<void> _handlePushNotificationToken() async {
    //Get the FCM token for the device
    getFcmToken();

    //Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          debugPrint("FCM token refreshed: $fcmToken");
        })
        .onError((error) {
          debugPrint("Error refreshing FCM token: $error");
        });
  }

  //Requests notification permission from the user
  Future<void> _requestPermission() async {
    //Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    //Log tge user's permission decision

    debugPrint("User granted permission: ${result.authorizationStatus}");
  }

  //Handles messages received while the app is in foreground
  void _onForegroundMessage(RemoteMessage message) async {
    debugPrint("Foreground message received: ${message.data.toString()}");
    final notificationData = message.notification;

    if (notificationData != null) {
      //Display a local notification using the service
      _localNotificationService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint(
      'Notification caused the app to open: ${message.data.toString()}',
    );
    // TODO: Add navigation or specific handling based on message data
  }

  Future<bool> areNotificationsEnabled() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}

//Background message handler (must be top-level function or static)
//Handles messages when the app is fully terminated
@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Handle the message
  debugPrint("Background message received: ${message.data.toString()}");
}
