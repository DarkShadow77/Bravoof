import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:Bravoo/session/session_manager.dart';
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

  Future<Either<String, UserProfile>> fetchUserProfile() async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      UserProfile userProfile = UserProfile.fromJson(response);

      log("User Profile Res $response");
      Logger().d("User Profile Res $response");

      SessionManager().pointsVal = userProfile.totalPoints;
      SessionManager().jackpotVal = userProfile.spins;
      return Right(userProfile);
    } catch (e) {
      return Left(e.toString());
    }
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

      SessionManager().pointsVal = updatedUserProfile.totalPoints;
      SessionManager().jackpotVal = updatedUserProfile.spins;
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
