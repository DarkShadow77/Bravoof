import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flowva/features/dashboard/home/data/model/notification_model.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final supabase = Supabase.instance.client;

  /// Fetch active community mission
  Future<Either<String, List<NotificationModel>>> fetchNotifications() async {
    try {
      final res = await supabase.functions.invoke(
        'get-user-notifications',
        body: {'user_id': supabase.auth.currentUser!.id},
      );

      log("Notification Result Response $res");
      Logger().d("Notification Result Response $res");

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(data['message'] ?? 'Failed to Retrieve Notifications');
      }

      if (data["notifications"] is List) {
        final notification = data["notifications"] as List;
        return Right(
          notification.map((e) => NotificationModel.fromJson(e)).toList(),
        );
      }

      return Left(data['message'] ?? 'Failed to Retrieve Notifications');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> markNotificationAsRead({
    required int notificationId,
  }) async {
    try {
      final res = await supabase.functions.invoke(
        'mark-notification-read',
        body: {'notification_id': notificationId},
      );

      Logger().d("Mark Notification Read Response $res");

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(data['message'] ?? 'Notification as Read failed');
      }
      return Right("Successfully Marked Notification as Read");
    } catch (e, s) {
      Logger().e("Notification as Read crashed E:$e, S:$s");
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> markAllNotificationAsRead() async {
    try {
      final res = await supabase.functions.invoke(
        'mark-all-notifications-read',
        body: {'user_id': supabase.auth.currentUser!.id},
      );

      Logger().d("Mark All Notification Read Response $res");

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(data['message'] ?? 'All Notification as Read failed');
      }
      return Right("Successfully Marked All Notification as Read");
    } catch (e, s) {
      Logger().e("All Notification as Read crashed E:$e, S:$s");
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> clearNotification() async {
    try {
      final res = await supabase.functions.invoke(
        'clear-user-notifications',
        body: {'user_id': supabase.auth.currentUser!.id},
      );

      Logger().d("Clear All Notification Response $res");

      Logger().d("🟢 Raw function response: ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      Logger().d("🟢 Parsed data: $data");

      if (data['success'] != true) {
        return Left(data['message'] ?? 'Clear All Notification failed');
      }
      return Right("Successfully Cleared All Notification");
    } catch (e, s) {
      Logger().e("Clear All Notification crashed E:$e, S:$s");
      return Left(e.toString());
    }
  }
}
