import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../common/model/app_base_response.dart';
import '../model/email_check_model.dart';
import '../model/enums.dart';
import '../model/referral_response_model.dart';

abstract class AuthRepository {
  Future<Either<String, EmailCheckResult>> checkEmail({
    required String email,
    required EmailCheckContext context,
  });
  Future<Either<String, AppBaseResponse>> signIn({
    required String email,
    required String password,
  });
  Future<Either<String, AppBaseResponse>> googleAuth();
  Future<Either<String, AppBaseResponse>> appleAuth();
  Future<Either<String, String>> sendOtp({
    required String email,
    required OtpContext context,
  });
  Future<Either<String, String>> resendOtp({
    required String email,
    required OtpContext context,
  });
  Future<Either<String, AppBaseResponse>> completeOnboarding({
    required String otp,
    required Map<String, dynamic> profile,
    required File imageFile,
  });
  Future<Either<String, String>> forgotPassword({required String email});
  Future<Either<String, String>> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  });
  Future<Either<String, AppBaseResponse>> resetPassword({
    required String password,
    required String confirmPassword,
  });
  Future<Either<String, ReferralResult>> verifyReferralCode({
    required String code,
  });
}
