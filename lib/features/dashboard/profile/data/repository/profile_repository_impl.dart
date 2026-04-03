import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bravoo/features/dashboard/profile/data/model/user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/firebase_messaging_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final supabase = Supabase.instance.client;
  final firebase = FirebaseMessagingService.instance();

  /*Future<Either<String, UserProfile>> fetchUserProfile() async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      UserProfile userProfile = UserProfile.fromJson(response);
      return Right(userProfile);
    } catch (e) {
      return Left(e.toString());
    }
  }*/

  Future<Either<String, UserProfile>> fetchUserProfile() async {
    return ApiService.instance!.invokeEdgeFunction<UserProfile>(
      functionName: 'get-profile',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Profile',
      onSuccess: (data) {
        log("Profile: ${data["data"]}");
        return UserProfile.fromJson(data["data"]);
      },
    );
  }

  Future<Either<String, UserProfile>> updateProfile({
    required UserProfile profile,
    File? imageFile,
  }) async {
    final token = supabase.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'profile': jsonEncode(profile.toJson()),
      if (imageFile != null)
        'profile_pic': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });

    final response = await ApiService.instance!.postRequestHandler(
      "functions/v1/update-profile",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
      transform: (dynamic res) {
        return UserProfile.fromJson(res);
      },
    );

    Logger().d("Update Profile Response $response");

    if (response.responseSuccessful == true) {
      final updatedUserProfile = response.responseBody!;

      return Right(updatedUserProfile);
    } else {
      return Left(response.responseMessage ?? "Failed to Update Profile");
    }
  }

  Future<Either<String, void>> updateCoverPic({required File imageFile}) async {
    final token = supabase.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'cover_pic': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/update-cover-pic",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Update Cover Pic Response $response");

    if (response.responseSuccessful == true) {
      return Right(null);
    } else {
      return Left(response.responseMessage ?? "Failed to Update Cover Pic");
    }
  }

  Future<Either<String, String>> updateLocation() async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'get_and_update_user_location',
      body: {},
      fallbackErrorMessage: "Failed to Fetch User Location",
      onSuccess: (data) => "Successfully fetched User Location",
    );
  }

  Future<Either<String, String>> deleteAccount({
    required String userId,
    required String reason,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'user-delete-account',
      body: {"userId": userId, "reason": reason},
      fallbackErrorMessage: "Failed to Delete User Account",
      onSuccess: (data) => "Account deleted successfully",
    );
  }

  Future<Either<String, String>> logUserHomeActivity() async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'log-user-home-activity',
      body: {
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": await firebase.getDeviceId(),
      },
      fallbackErrorMessage: "Failed to Log User Home Activity",
      onSuccess: (data) => "logged User Home Activity successfully",
    );
  }

  Future<Either<String, String>> logUserLoginActivity({
    required String eventType,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'log-user-login-activity',
      body: {
        "platform": Platform.isAndroid ? "android" : "ios",
        "event_type": eventType,
        "device_id": await firebase.getDeviceId(),
        "app_version": await firebase.getAppVersion(),
      },
      fallbackErrorMessage: "Failed to Log User Login Activity",
      onSuccess: (data) => "logged User Login Activity successfully",
    );
  }

  Future<Either<String, String>> logUserLogoActivity({
    required String userId,
    required String logoString,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'save-user-logo-activity',
      body: {
        'userId': userId,
        "platform": Platform.isAndroid ? "android" : "ios",
        "logoName": logoString,
      },
      fallbackErrorMessage: "Failed to Log User Logo Activity",
      onSuccess: (data) => "logged User Logo Activity successfully",
    );
  }

  Future<Either<String, void>> saveFCMToken() async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'save-fcm-token',
      body: {
        "fcm_token": await firebase.getFcmToken(),
        "device_id": await firebase.getDeviceId(),
        "platform": Platform.isAndroid ? "android" : "ios",
        "app_version": await firebase.getAppVersion(),
      },
      fallbackErrorMessage: "Failed to Save FCM Token",
      onSuccess: (data) => "Successfully Saved FCM Token",
    );
  }

  Future<Either<String, void>> deleteFCMToken() async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'delete-fcm-token',
      body: {"fcm_token": firebase.getFcmToken()},
      fallbackErrorMessage: "Failed to Delete FCM Token",
      onSuccess: (data) => "Successfully Deleted FCM Token",
    );
  }

  Future<Either<String, void>> sendPushNotification() async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'send-push-notification',
      body: {
        'userId': supabase.auth.currentUser!.id,
        'title': 'New Alert',
        'body': 'Something happened 🔔',
        'data': {'type': 'transaction', 'id': '123'},
      },
      fallbackErrorMessage: "Failed to Send Push Notification",
      onSuccess: (data) => "Successfully Sent Push Notification",
    );
  }
}
