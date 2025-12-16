import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/data/constants.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/features/onbaording/data/signup_repository/signup_repository.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupRepositoryImpl extends SignupRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, AppBaseResponse>> signUp({
    UserProfile? userProfile,
  }) async {
    try {
      var encode = userProfile!.toJson();
      final res = await supabase
          .from('user_profile')
          .select()
          .eq('email', encode['email']);
      print(res);
      if (res.isNotEmpty) return Left("This user already have an account");
      Constants().setUser(encode);

      await supabase.auth.signInWithOtp(email: encode['email']);

      AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
      return Right(appBaseResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> forgotPassword({
    required String email,
  }) async {
    try {
      // 1. Check provider collision BEFORE sign-in
      final existing = await supabase.rpc(
        'get_user_auth_provider',
        params: {'user_email': email},
      );

      log("Existing Login User: $existing ");

      if (existing != null) {
        final provider = existing['raw_app_meta_data']?['provider'];

        if (provider != null && provider != 'email') {
          return Left(
            "This email is registered using $provider login. "
            "Please sign in using $provider.",
          );
        }
      } else {
        return Left("This email is not registered");
      }

      await supabase.auth.signInWithOtp(email: email, shouldCreateUser: false);

      AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
      return Right(appBaseResponse);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> signIn({
    UserProfile? userProfile,
  }) async {
    try {
      var encode = userProfile!.toJson();
      final response = await supabase.auth.signInWithPassword(
        email: encode['email'],
        password: encode['pass']!,
      );

      if (response.user != null) {
        print(response.user);
        SessionManager().userIdVal = response.user!.id;
        AppBaseResponse appBaseResponse = AppBaseResponse(status: true);
        return Right(appBaseResponse);
      } else {
        return Left("Invalid credentials");
      }
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, AppBaseResponse>> resetPassword({
    required String password,
  }) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: password));

      // Optional: sign out after reset
      await supabase.auth.signOut();

      return Right(
        AppBaseResponse(status: true, message: "PASSWORD_RESET_SUCCESS"),
      );
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, UserProfile>> updateProfile({UserProfile? data}) async {
    try {
      print(data!.toJson());
      final res = await supabase
          .from('user_profile')
          .update(data.toJson())
          .eq('user_id', SessionManager().userIdVal)
          .select()
          .single(); // if you expect only one row

      UserProfile userProfile = UserProfile.fromJson(res);
      return Right(userProfile);
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, UserProfile>> fetchUserProfile() async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', SessionManager().userIdVal)
          .single();
      if (response != null) {
        UserProfile userProfile = UserProfile.fromJson(response);

        SessionManager().pointsVal = userProfile.totalPoints!;
        return Right(userProfile);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> uploadProfileImage(File imageFile) async {
    final fileName = '${basename(imageFile.path)}';

    try {
      await supabase.storage
          .from('test-avatar')
          .upload(
            '$fileName',
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get the public URL for the image
      final publicUrl = supabase.storage
          .from('test-avatar')
          .getPublicUrl('$fileName');
      return Right(publicUrl);
    } catch (e) {
      print('❌ Upload failed: $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, AppBaseResponse>> googleAuth() async {
    try {
      const iosClientId =
          '413861787586-2p9vbmc723dmhnf39v967hjln3cr311m.apps.googleusercontent.com';
      const webClientId =
          '413861787586-j4cmqdvelmdgpkchpg5q6cug6kklbf52.apps.googleusercontent.com';

      final GoogleSignIn signIn = GoogleSignIn.instance;

      // At the start of your app, initialize the GoogleSignIn instance
      unawaited(
        signIn.initialize(clientId: iosClientId, serverClientId: webClientId),
      );

      // Perform the sign in
      final googleAccount = await signIn.authenticate();
      final googleAuthorization = await googleAccount.authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final googleAuthentication = googleAccount.authentication;
      final googleEmail = googleAccount.email;

      // 1. Check provider collision BEFORE sign-in
      final existing = await supabase.rpc(
        'get_user_auth_provider',
        params: {'user_email': googleEmail},
      );

      log("Existing Login User: $existing ");

      if (existing != null) {
        final provider = existing['raw_app_meta_data']?['provider'];

        if (provider != null && provider != 'google') {
          return Left(
            "This email is already registered using $provider login. "
            "Please sign in using $provider.",
          );
        }
      }

      // 2. No collision. Continue Google login
      final idToken = googleAuthentication.idToken;
      final accessToken = googleAuthorization?.accessToken;

      if (idToken == null || accessToken == null) {
        return Left("Missing Google auth tokens");
      }

      // Start Google OAuth
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Auth will complete through the redirect link.
      final user = supabase.auth.currentUser;

      if (user == null) {
        log("Google Login Failed ");
        return Left("Google login failed");
      }

      log("Google Logged In $user");

      // Check if user exists in your user_profile table
      final check = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', user.id);

      if (check.isNotEmpty) {
        // Existing user → login success
        SessionManager().userIdVal = user.id;
        SessionManager().hasAccountVal = true;

        return Right(AppBaseResponse(status: true));
      }

      // NEW USER: mimic your email sign-up flow
      final tempProfile = {
        "email": user.email,
        "pass": null, // Google password not needed
        "profile_image": user.userMetadata?['avatar_url'],
        "name": user.userMetadata?['full_name'],
        "user_id": user.id,
      };

      // Store temp profile exactly like email flow
      Constants().setUser(tempProfile);

      // Tell the UI to continue onboarding
      return Right(AppBaseResponse(status: true, message: "NEW_GOOGLE_USER"));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AppBaseResponse>> appleAuth() async {
    try {
      AuthResponse? response;
      if (Platform.isIOS || Platform.isMacOS) {
        final rawNonce = supabase.auth.generateRawNonce();
        final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

        // 2. Request credential
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );

        final idToken = credential.identityToken;
        final appleEmail = credential.email;

        if (idToken == null) {
          return Left("Unable to retrieve Apple identity token");
        }

        // 3. Check provider collision BEFORE Supabase login
        if (appleEmail != null) {
          final existing = await supabase.rpc(
            'get_user_auth_provider',
            params: {'user_email': appleEmail},
          );

          if (existing != null) {
            final provider = existing['raw_app_meta_data']?['provider'];

            if (provider != null && provider != 'apple') {
              await supabase.auth.signOut();
              return Left(
                "This email is already registered using $provider login. "
                "Please sign in with $provider.",
              );
            }
          }
        }

        // 4. Sign in at Supabase
        response = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } else {
        await supabase.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: 'com.flowva.bravoo://apple-login-callback',
          authScreenLaunchMode: LaunchMode.externalApplication,
        );

        final user = supabase.auth.currentUser;
        if (user == null) return Left("Apple login failed");

        // 3. Check provider collision BEFORE Supabase login
        if (user.email != null) {
          final existing = await supabase.rpc(
            'get_user_auth_provider',
            params: {'user_email': user.email},
          );

          if (existing != null) {
            final provider = existing['raw_app_meta_data']?['provider'];

            if (provider != null && provider != 'apple') {
              return Left(
                "This email is already registered using $provider login. "
                "Please sign in with $provider.",
              );
            }
          }
        }
      }

      final user = response?.user ?? supabase.auth.currentUser;
      if (user == null) return Left("Apple login failed");

      // 5. Is this an EXISTING user?
      final check = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', user.id);

      if (check.isNotEmpty) {
        SessionManager().userIdVal = user.id;
        SessionManager().hasAccountVal = true;
        return Right(AppBaseResponse(status: true));
      }

      // 6. NEW USER: mimic your Google/Email onboarding
      final name =
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          'Apple User';

      final tempProfile = {
        "email": user.email, // Apple sometimes hides real email for first login
        "pass": null,
        "profile_image": null,
        "name": name,
        "user_id": user.id,
      };

      Constants().setUser(tempProfile);

      return Right(AppBaseResponse(status: true, message: "NEW_APPLE_USER"));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
