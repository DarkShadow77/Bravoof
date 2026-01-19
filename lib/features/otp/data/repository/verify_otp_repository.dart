import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flowva/features/common/data/constants.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../core/services/api_service.dart';

class VerifyOtpRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, AppBaseResponse>> verifyOtp({
    required String otp,
  }) async {
    final currentSession = supabase.auth.currentSession;
    final user = currentSession?.user;

    var userProfile = await Constants().getUser();
    final token = currentSession?.accessToken ?? "";
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
    if (user != null) {
      final response = await ApiService.instance!.postRequest(
        "functions/v1/verify-register-user",
        formData,
        accessToken: token,
        apiKey: dotenv.env["ANON_KEY"] ?? "",
      );

      Logger().d("Create User Response $response");

      if (response.responseSuccessful == true) {
        final data = response.responseBody!;

        SessionManager().userIdVal = data["user_id"];
        SessionManager().hasAccountVal = true;
        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left(response.responseMessage ?? "Failed to Update Profile");
      }
    }

    return Left("Invalid Sign Up");
  }

  /* Future<Either<String, AppBaseResponse>> verifyOtp({String? otp}) async {
    try {
      final user = supabase.auth.currentSession?.user;
      var userProfile = await Constants().getUser();
      final fileName = '${basename(userProfile['profile_image'])}';

      var res = await supabase.auth.verifyOTP(
        email: userProfile['email'],
        token: otp,
        type: OtpType.email,
      );
      final exists = await supabase.storage
          .from('profile_pic')
          .list(
            path: '',
            searchOptions: SearchOptions(search: fileName),
          );
      if (exists.isEmpty) {
        await supabase.storage
            .from('profile_pic')
            .upload(
              '$fileName',
              File(userProfile['profile_image']),
              // fileOptions: const FileOptions(upsert: true),
            );
      }

      final publicUrl = supabase.storage
          .from('profile_pic')
          .getPublicUrl('$fileName');

      if (user != null) {
        if ((userProfile['pass'].toString() ?? "").isNotEmpty) {
          await supabase.auth.updateUser(
            UserAttributes(password: userProfile['pass']),
          );
        }

        userProfile['user_id'] = user.id;
        userProfile['profile_image'] = publicUrl;
        SessionManager().userIdVal = user.id;
        SessionManager().hasAccountVal = true;

        final res = await createProfile(userProfile);

        await applyReferralIfAny(user.id);

        if (res == res['statusCode']) return Left(res['message']);
        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left("An Error has Occurred");
      }
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }*/

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

  Future<dynamic> createProfile(Map<String, dynamic> data) async {
    try {
      log("UserProfile $data");
      final insert = {
        'name': data['name'],
        'email': data['email'],
        'goals': data['goals'],
        'bio': "Say Something nice about yourself...",
        'referral_code': data['referral_code'],
        'profile_image': data['profile_image'],
        'user_id': data['user_id'],
      };
      var res = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', data['user_id'])
          .maybeSingle();

      if (res != null) {
        await supabase.auth.signInWithPassword(
          email: data['email'],
          password: data['pass']!,
        );

        return res;
      }
      final response = await supabase
          .from("user_profile")
          .insert([insert])
          .select()
          .single();
      SessionManager().userEmailval = data['email'];

      // 📨 Create notification (non-blocking)
      String notificationTitle = "Welcome to Bravoo 🎉";

      String notificationMessage =
          "Hey there, Rockstar! You’ve just scored **50 Bravoo coins** to kick off your journey. Complete fun missions, build real tech skills and stack up even more rewards. Your adventure starts **NOW** — let’s make it even more epic! 🚀";
      await supabase.from("notification").insert({
        "user_id": data['user_id'],
        "title": notificationTitle,
        "message": notificationMessage,
        "read": false,
      });

      return response;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> applyReferralIfAny(String userId) async {
    var userProfile = await Constants().getUser();
    final referralCode = userProfile['referral_code'];

    if (referralCode == null) return;

    await supabase.rpc(
      'apply_referral',
      params: {'new_user_id': userId, 'referral_code_input': referralCode},
    );
  }
}
