import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, UserProfile>> fetchUserProfile() async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', SessionManager().userIdVal)
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
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
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

  Future<Either<String, UserProfile>> updateCoverPic({
    required File imageFile,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'cover_pic': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await ApiService.instance!.postRequestHandler(
      "functions/v1/update-cover-pic",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
      transform: (dynamic res) {
        return UserProfile.fromJson(res);
      },
    );

    Logger().d("Update Cover Pic Response $response");

    if (response.responseSuccessful == true) {
      final updatedUserProfile = response.responseBody!;

      SessionManager().pointsVal = updatedUserProfile.totalPoints;
      SessionManager().jackpotVal = updatedUserProfile.spins;
      return Right(updatedUserProfile);
    } else {
      return Left(response.responseMessage ?? "Failed to Update Cover Pic");
    }
  }

  /*
  Future<void> updateProfileEdge({
    required UserProfile profile,
    File? imageFile,
  }) async {
    try {
      final dio = Dio();

      // Build FormData
      final formData = FormData.fromMap({
        'profile': jsonEncode(profile.toJson()),
        if (imageFile != null)
          'profile_pic': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await dio.post(
        '${Supabase.instance.client.supabaseUrl}/functions/v1/update-profile',
        data: formData,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
            'apikey': Supabase.instance.client.supabaseKey,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("🟢 Raw response: ${response.data}");

      if (response.data['success'] == true) {
        print("✅ Profile updated successfully");
        final updatedUserProfile = UserProfile.fromJson(response.data['data']);
        // Update your local state/session here
      } else {
        print("❌ Update failed: ${response.data['message']}");
      }
    } catch (e) {
      print("🔥 Edge function call failed: $e");
    }
  }*/

  /*  Future<Either<String, UserProfile>> updateProfile({
    required UserProfile profile,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;

      // 🖼 Upload image ONLY if provided
      if (imageFile != null) {
        final fileName = basename(imageFile.path);

        await supabase.storage
            .from('profile_pic')
            .upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(upsert: true),
            );

        imageUrl = supabase.storage.from('profile_pic').getPublicUrl(fileName);
      }

      // 🧠 Merge new image URL if exists
      final updatedProfile = imageUrl != null
          ? {"profile_image": imageUrl}
          : {"name": profile.name, "bio": profile.bio};

      final res = await supabase
          .from('user_profile')
          .update(updatedProfile)
          .eq('user_id', SessionManager().userIdVal)
          .select()
          .single();

      final userProfile = UserProfile.fromJson(res);

      SessionManager().pointsVal = userProfile.totalPoints ?? 0;
      SessionManager().jackpotVal = userProfile.spins ?? 0;

      return Right(userProfile);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }*/

  /*  Future<Either<String, UserProfile>> updateCoverPic({
    required File imageFile,
  }) async {
    try {
      // 🖼 Upload image ONLY if provided
      String? imageUrl;

      final fileName = basename(imageFile.path);

      await supabase.storage
          .from('profile_pic')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      imageUrl = supabase.storage.from('profile_pic').getPublicUrl(fileName);

      final res = await supabase
          .from('user_profile')
          .update({"cover_pic": imageUrl})
          .eq('user_id', SessionManager().userIdVal)
          .select()
          .single();

      final userProfile = UserProfile.fromJson(res);

      SessionManager().pointsVal = userProfile.totalPoints;
      SessionManager().jackpotVal = userProfile.spins;

      return Right(userProfile);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }*/
}
