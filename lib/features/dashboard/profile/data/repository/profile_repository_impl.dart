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

  Future<Either<String, void>> updateCoverPic({required File imageFile}) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
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
}
