import 'dart:convert';

import 'package:Bravoo/features/common/data/constants.dart';
import 'package:Bravoo/features/common/model/app_base_response.dart';
import 'package:Bravoo/session/session_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../core/services/api_service.dart';

class VerifyOtpRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, AppBaseResponse>> verifyOtp({
    required String otp,
  }) async {
    var userProfile = await Constants().getUser();
    final formData = FormData.fromMap({
      'otp': otp,
      'profile': jsonEncode({
        'email': userProfile["email"],
        'name': userProfile["name"],
        'goals': userProfile["goals"],
        'referral_code': userProfile["referral_code"],
        'pass': userProfile["pass"],
      }),
      'image': await MultipartFile.fromFile(
        userProfile["profile_image"],
        filename: userProfile["profile_image"].split('/').last,
      ),
    });
    final response = await ApiService.instance!.postRequestHandler(
      "functions/v1/verify-register-user",
      formData,
      accessToken: dotenv.env["ANON_KEY"] ?? "",
      apiKey: dotenv.env["ANON_KEY"] ?? "",
      transform: (data) {
        return {'session': data['session'], 'user_id': data['user_id']};
      },
    );

    Logger().d("Create User Response $response");

    if (response.responseSuccessful == true) {
      // 2️⃣ If password is set, sign in with email + password to get a proper session
      if (userProfile["pass"] != null && userProfile["pass"].isNotEmpty) {
        final authResponse = await supabase.auth.signInWithPassword(
          email: userProfile["email"],
          password: userProfile["pass"],
        );

        if (authResponse.session != null) {
          SessionManager().hasAccountVal = true;
          Logger().d("Signed in with password, session active.");
          return Right(AppBaseResponse(status: true));
        } else {
          return Left("Failed to sign in with password");
        }
      } else {
        SessionManager().hasAccountVal = true;
        return Right(AppBaseResponse(status: true));
      }
    } else {
      return Left(response.responseMessage ?? "Failed to Update Profile");
    }
  }

  Future<Either<String, void>> resendOtp(String email) async {
    try {
      await supabase.auth.signInWithOtp(email: email);
      return Right("New OTP sent to your email ");
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left("Unable to resend OTP");
    }
  }

  Future<Either<String, AppBaseResponse>> verifyResetPasswordOtp({
    required Map<String, dynamic> otp,
  }) async {
    try {
      await supabase.auth.verifyOTP(
        email: otp['email'],
        token: otp['otp'],
        type: OtpType.email,
      );

      AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
      return Right(appBaseResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }
}
