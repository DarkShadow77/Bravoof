import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/api_service.dart';
import '../model/oauth_link_initiate_response.dart';

class AuthLinkingService {
  final _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // ═══════════════════════════════════════════════════════════════
  // INITIATE GOOGLE LINK
  // ═══════════════════════════════════════════════════════════════

  Future<Either<String, OAuthLinkInitiateResponse>> initiateGoogleLink() async {
    try {
      // Check if user is authenticated
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return const Left('You must be logged in to link accounts');
      }

      final iosClientId = dotenv.env["IOS_CLIENT_ID"] ?? "";
      final webClientId = dotenv.env["WEB_CLIENT_ID"] ?? "";

      await _googleSignIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      // Perform the sign in
      final googleAccount = await _googleSignIn.authenticate();
      final googleAuthorization = await googleAccount.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      if (googleAuthorization == null) {
        return const Left('Google sign-in cancelled');
      }

      final accessToken = googleAuthorization.accessToken;

      return ApiService.instance!.invokeEdgeFunction<OAuthLinkInitiateResponse>(
        functionName: 'initiate-oauth-link',
        body: {'provider': 'google', 'access_token': accessToken},
        fallbackErrorMessage: 'Failed to initiate Google account linking',
        onSuccess: (data) => OAuthLinkInitiateResponse.fromJson(data['data']),
      );
    } catch (e) {
      return Left('Error initiating Google link: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // INITIATE APPLE LINK
  // ═══════════════════════════════════════════════════════════════

  Future<Either<String, OAuthLinkInitiateResponse>> initiateAppleLink() async {
    try {
      // Check if user is authenticated
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return const Left('You must be logged in to link accounts');
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) {
        return const Left('Failed to get Apple ID token');
      }

      return ApiService.instance!.invokeEdgeFunction<OAuthLinkInitiateResponse>(
        functionName: 'initiate-oauth-link',
        body: {'provider': 'apple', 'id_token': credential.identityToken},
        fallbackErrorMessage: 'Failed to initiate Apple account linking',
        onSuccess: (data) => OAuthLinkInitiateResponse.fromJson(data['data']),
      );
    } catch (e) {
      return Left('Error initiating Apple link: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // VERIFY AND COMPLETE LINK
  // ═══════════════════════════════════════════════════════════════

  Future<Either<String, OAuthLinkVerifyResponse>> verifyAndCompleteLink(
    String verificationCode,
  ) async {
    return ApiService.instance!.invokeEdgeFunction<OAuthLinkVerifyResponse>(
      functionName: 'verify-oauth-link',
      body: {'verification_code': verificationCode},
      fallbackErrorMessage: 'Failed to verify account link',
      onSuccess: (data) => OAuthLinkVerifyResponse.fromJson(data['data']),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ADD PASSWORD
  // ═══════════════════════════════════════════════════════════════

  Future<Either<String, String>> addPassword(String password) async {
    if (password.length < 6) {
      return const Left('Password must be at least 6 characters');
    }

    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'add-password',
      body: {'password': password},
      fallbackErrorMessage: 'Failed to add password',
      onSuccess: (data) => data['message'] ?? 'Password added successfully',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // UNLINK PROVIDER
  // ═══════════════════════════════════════════════════════════════

  Future<Either<String, String>> unlinkProvider(String provider) async {
    return ApiService.instance!.invokeEdgeFunction<String>(
      functionName: 'unlink-provider',
      body: {'provider': provider},
      fallbackErrorMessage: 'Failed to unlink provider',
      onSuccess: (data) => data['message'] ?? 'Provider unlinked successfully',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SIGN OUT FROM GOOGLE
  // ═══════════════════════════════════════════════════════════════

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Silent fail
    }
  }
}
