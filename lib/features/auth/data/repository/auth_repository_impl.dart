import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../core/services/api_service.dart';
import '../../../../session/session_manager.dart';
import '../../../common/data/constants.dart';
import '../../../common/model/app_base_response.dart';
import '../model/email_check_model.dart';
import '../model/enums.dart';
import '../model/referral_response_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final _logger = Logger();

  Future<Either<String, EmailCheckResult>> checkEmail({
    required String email,
    required EmailCheckContext context,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<EmailCheckResult>(
      functionName: 'check-email',
      requiresAuth: false,
      body: {'email': email, 'context': context.value},
      fallbackErrorMessage: 'Failed to check email',
      onSuccess: (data) => EmailCheckResult.fromJson(data['data']),
    );
  }

  Future<Either<String, AppBaseResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return Right(AppBaseResponse(status: true, message: "EXISTING_USER"));
      } else {
        return Left("Invalid credentials");
      }
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> googleAuth() async {
    try {
      _logger.i('Starting Google authentication');

      await _googleSignIn.initialize(
        clientId: dotenv.env['IOS_CLIENT_ID'] ?? '',
        serverClientId: dotenv.env['WEB_CLIENT_ID'] ?? '',
      );

      final googleAccount = await _googleSignIn.authenticate();
      final googleAuthorization = await googleAccount.authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final googleAuthentication = googleAccount.authentication;

      final idToken = googleAuthentication.idToken;
      final accessToken = googleAuthorization?.accessToken;

      if (idToken == null || accessToken == null) {
        _logger.e('Missing Google auth tokens');
        return const Left('Missing Google auth tokens');
      }

      // ─── Call Edge Function (validation only) ───────────────────
      final result = await ApiService.instance!
          .invokeEdgeFunction<Map<String, dynamic>>(
            functionName: 'google-auth',
            requiresAuth: false,
            body: {'id_token': idToken, 'access_token': accessToken},
            fallbackErrorMessage: 'Google authentication failed',
            onSuccess: (data) => data['data'] as Map<String, dynamic>,
          );

      if (result.isLeft()) return Left(result.fold((l) => l, (_) => ''));

      // ─── Flutter signs in directly ──────────────────────────────
      final authResponse = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return _handleSocialAuthResponse(
        status: result.getOrElse(() => {})['status'] as String,
        responseData: result.getOrElse(() => {}),
        user: authResponse.user,
        provider: 'GOOGLE',
        overrideName: null,
      );
    } on GoogleSignInException catch (e) {
      _logger.e('Google Sign In Exception', error: e);
      return Left('Google sign-in failed: $e');
    } catch (e, s) {
      _logger.e('Google auth failed', error: e, stackTrace: s);
      return Left('Google authentication failed: ${e.toString()}');
    }
  }

  Future<Either<String, AppBaseResponse>> appleAuth() async {
    try {
      _logger.i('Starting Apple authentication');

      if (!Platform.isIOS && !Platform.isMacOS) {
        return const Left('Apple Sign In is only supported on iOS and macOS');
      }

      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null)
        return const Left('Unable to retrieve Apple identity token');

      // ─── Call Edge Function (validation only) ───────────────────
      final result = await ApiService.instance!
          .invokeEdgeFunction<Map<String, dynamic>>(
            functionName: 'apple-auth',
            requiresAuth: false,
            body: {
              'id_token': idToken,
              'nonce': rawNonce,
              'given_name': credential.givenName,
              'family_name': credential.familyName,
              'email': credential.email,
            },
            fallbackErrorMessage: 'Apple authentication failed',
            onSuccess: (data) => data['data'] as Map<String, dynamic>,
          );

      if (result.isLeft()) return Left(result.fold((l) => l, (_) => ''));

      // ─── Flutter signs in directly ──────────────────────────────
      final authResponse = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // Build captured name from Apple credential (only available on first sign-in)
      final capturedName =
          credential.givenName != null || credential.familyName != null
          ? '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim()
          : null;

      return _handleSocialAuthResponse(
        status: result.getOrElse(() => {})['status'] as String,
        responseData: result.getOrElse(() => {}),
        user: authResponse.user,
        provider: 'APPLE',
        overrideName: capturedName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      _logger.e('Apple Sign In Exception', error: e);
      if (e.code == AuthorizationErrorCode.canceled) {
        return const Left('Apple sign-in cancelled');
      }
      return Left('Apple sign-in failed: ${e.message}');
    } catch (e, s) {
      _logger.e('Apple auth failed', error: e, stackTrace: s);
      return Left('Apple authentication failed: ${e.toString()}');
    }
  }

  Future<Either<String, String>> sendOtp({
    required String email,
    required OtpContext context,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'send-otp',
      requiresAuth: false,
      body: {'email': email, 'context': context.value},
      fallbackErrorMessage: 'Failed to send verification code',
      onSuccess: (data) => data['message'] ?? 'Verification code sent',
    );
  }

  Future<Either<String, String>> resendOtp({
    required String email,
    required OtpContext context,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'resend-otp',
      requiresAuth: false,
      body: {'email': email, 'context': context.value},
      fallbackErrorMessage: 'Failed to resend verification code',
      onSuccess: (data) => data['message'] ?? 'New code sent',
    );
  }

  Future<Either<String, AppBaseResponse>> completeOnboarding({
    required String otp,
    required Map<String, dynamic> profile,
    required File imageFile,
  }) async {
    try {
      _logger.i(
        'Starting onboarding completion',
        error: {
          'email': profile['email'],
          'hasSession': _supabase.auth.currentSession != null,
        },
      );

      // ─── Build form data ───────────────────────────────────────────
      final formData = FormData.fromMap({
        'otp': otp,
        'profile': jsonEncode(profile),
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // ─── Get auth token ────────────────────────────────────────────
      // Social users already have a session from signInWithIdToken
      // Email users don't have one yet — use anon key
      final existingSession = _supabase.auth.currentSession;
      final isSocialUser = existingSession != null;
      final authToken =
          existingSession?.accessToken ?? dotenv.env['ANON_KEY'] ?? '';

      _logger.d(
        'Auth token determined',
        error: {
          'isSocialUser': isSocialUser,
          'userId': existingSession?.user.id,
        },
      );

      // ─── Call edge function ────────────────────────────────────────
      final response = await ApiService.instance!.postRequestHandler(
        'functions/v1/complete-onboarding',
        formData,
        accessToken: authToken,
        apiKey: dotenv.env['ANON_KEY'] ?? '',
        transform: (data) => data,
      );

      if (response.responseSuccessful != true) {
        return Left(response.responseMessage ?? 'Onboarding failed');
      }

      // ─── Create Flutter session ────────────────────────────────────
      if (isSocialUser) {
        // Social user: session already active — nothing to do
        _logger.i(
          'Social user — session already active',
          error: {'userId': existingSession.user.id},
        );
      } else {
        // Email user: edge function consumed the OTP, so sign in with password
        // OTP-only users (no password) will need to sign in manually
        _logger.i('Email user — creating session after onboarding');

        final signInResult = await _signInAfterOnboarding(profile);

        if (signInResult.isLeft()) {
          // Profile was created successfully but we couldn't create a session
          // Return a specific message so the UI can redirect to sign-in
          final error = signInResult.fold((l) => l, (_) => '');
          _logger.w(
            'Session creation failed after onboarding',
            error: {'reason': error},
          );

          return Right(
            AppBaseResponse(status: true, message: 'ONBOARDED_NO_SESSION'),
          );
        }

        _logger.i(
          'Session created after onboarding',
          error: {'userId': _supabase.auth.currentUser?.id},
        );
      }

      SessionManager().hasAccountVal = true;

      _logger.i(
        'Onboarding completed successfully',
        error: {'userId': _supabase.auth.currentUser?.id},
      );

      return Right(AppBaseResponse(status: true, message: 'ONBOARDED_USER'));
    } catch (e, s) {
      _logger.e('Onboarding failed', error: e, stackTrace: s);
      return Left('Account creation failed: ${e.toString()}');
    }
  }

  // ─── Sign in after onboarding (email users only) ──────────────────
  // The OTP was consumed by the edge function so we must use password
  // Returns Left if sign-in failed (caller decides how to handle)
  Future<Either<String, bool>> _signInAfterOnboarding(
    Map<String, dynamic> profile,
  ) async {
    final email = profile['email'] as String;
    final password = profile['pass'] as String?;

    if (password == null || password.isEmpty) {
      _logger.w('No password set — user must sign in manually');
      return const Left('no_password');
    }

    try {
      final auth = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (auth.session == null) {
        _logger.e('Password sign-in returned null session');
        return const Left('null_session');
      }

      _logger.i(
        'Signed in via password after onboarding',
        error: {'userId': auth.user?.id},
      );

      return const Right(true);
    } on AuthException catch (e) {
      _logger.e('Password sign-in failed after onboarding', error: e.message);
      return Left(e.message);
    }
  }

  Future<Either<String, String>> forgotPassword({required String email}) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'forgot-password',
      requiresAuth: false,
      body: {'email': email},
      fallbackErrorMessage: 'Failed to send reset code',
      onSuccess: (data) => data['message'] ?? 'Verification code sent',
    );
  }

  Future<Either<String, String>> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      _logger.i('Verifying forgot password OTP directly on Flutter client');

      // Verify directly — no edge function needed here
      final authResponse = await _supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );

      if (authResponse.session == null || authResponse.user == null) {
        _logger.e('OTP verification returned null session');
        return const Left('Verification failed. Please try again.');
      }

      _logger.i(
        'Session created for password reset',
        error: {'userId': authResponse.user?.id},
      );

      return const Right('OTP verified successfully');
    } on AuthApiException catch (e) {
      _logger.e(
        'OTP verification failed',
        error: {
          'message': e.message,
          'code': e.code,
          'statusCode': e.statusCode,
        },
      );

      // Give user-friendly messages for common cases
      if (e.code == 'otp_expired') {
        return const Left('Code has expired. Please request a new one.');
      }

      return Left(e.message);
    } on AuthException catch (e) {
      _logger.e('Auth exception verifying OTP', error: e);
      return Left(e.message);
    } catch (e, s) {
      _logger.e('Failed to verify OTP', error: e, stackTrace: s);
      return Left('Failed to verify code: ${e.toString()}');
    }
  }

  Future<Either<String, AppBaseResponse>> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<AppBaseResponse>(
      functionName: 'reset-password',
      body: {'password': password, 'confirm_password': confirmPassword},
      fallbackErrorMessage: 'Failed to reset password',
      onSuccess: (data) =>
          AppBaseResponse(status: true, message: 'PASSWORD_RESET_SUCCESS'),
    );
  }

  Future<Either<String, ReferralResult>> verifyReferralCode({
    required String code,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<ReferralResult>(
      functionName: 'verify-referral-code',
      requiresAuth: false,
      body: {'code': code},
      fallbackErrorMessage: 'Failed to verify referral code',
      onSuccess: (data) => ReferralResult.fromJson(data['data']),
    );
  }

  Either<String, AppBaseResponse> _handleSocialAuthResponse({
    required String status,
    required Map<String, dynamic> responseData,
    required User? user,
    required String provider,
    required String? overrideName,
  }) {
    _logger.i(
      'Handling social auth response',
      error: {'status': status, 'provider': provider, 'userId': user?.id},
    );

    if (user == null) {
      _logger.e(
        'Flutter sign-in returned null user after edge function validation',
      );
      return const Left('Sign-in failed. Please try again.');
    }

    if (status == 'EXISTING_USER') {
      _logger.i('Existing $provider user — login successful');
      SessionManager().hasAccountVal = true;
      return Right(AppBaseResponse(status: true, message: status));
    }

    if (status == 'NEW_USER') {
      _logger.i('New $provider user — setting up onboarding');

      final tempProfile =
          responseData['temp_profile'] as Map<String, dynamic>? ?? {};

      Constants().setUser({
        'email': user.email ?? tempProfile['email'] ?? '',
        'pass': null,
        'profile_image': tempProfile['profile_image'],
        // Apple name only comes on first sign-in, so prefer overrideName
        'name': overrideName ?? tempProfile['name'] ?? '',
        'user_id': user.id,
      });

      final message = responseData['message'] as String?;
      return Right(AppBaseResponse(status: true, message: status));
    }

    _logger.w('Unknown auth status', error: {'status': status});
    return Left('Unexpected response from server');
  }
}
