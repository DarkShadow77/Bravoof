import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/data/constants.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyOtpRepository {
  final supabase = Supabase.instance.client;
  Future<Either<String, AppBaseResponse>> verifyOtp({String? otp}) async {
    var response;

    try {
      var userProfile = await Constants().getUser();
      final fileName = '${basename(userProfile['profile_image'])}';
      var res = await supabase.auth.verifyOTP(
        email: userProfile['email'],
        token: otp,
        type: OtpType.email,
      );
      final exists = await supabase.storage
          .from('test-avatar')
          .list(
            path: '',
            searchOptions: SearchOptions(search: fileName),
          );
      if (exists.isEmpty) {
        await supabase.storage
            .from('test-avatar')
            .upload(
              '$fileName',
              File(userProfile['profile_image']),
              // fileOptions: const FileOptions(upsert: true),
            );
      }

      final publicUrl = supabase.storage
          .from('test-avatar')
          .getPublicUrl('$fileName');
      if (res.user != null) {
        response = await supabase.auth.updateUser(
          UserAttributes(password: userProfile['pass']),
        );
      }

      if (response.user != null) {
        userProfile['user_id'] = response.user!.id;
        userProfile['profile_image'] = publicUrl;
        SessionManager().userIdVal = response.user!.id;
        SessionManager().hasAccountVal = true;

        final res = await createProfile(userProfile);

        if (res == res['statusCode']) return Left(res['message']);
        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left("An Error has Occurred");
      }
    } on AuthException catch (e) {
      return Left(e.message);
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

  Future<dynamic> createProfile(Map<String, dynamic> data) async {
    try {
      final insert = {
        'name': data['name'],
        'email': data['email'],
        'goals': data['goals'],
        'profile_image': data['profile_image'],
        'user_id': data['user_id'],
      };
      var res = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', data['user_id'])
          .maybeSingle();
      if (res != null) {
        final response = await supabase.auth.signInWithPassword(
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
      return response;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
