import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../../../core/services/api_service.dart';
import '../model/response/brand_mission_model.dart';
import '../model/response/brand_model.dart';
import 'brand_repository.dart';

class BrandRepositoryImpl extends BrandRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<Brand>>> fetchBrands() async {
    return ApiService.instance!.invokeEdgeFunction<List<Brand>>(
      functionName: 'fetch-brands',
      body: {},
      fallbackErrorMessage: 'Failed to Fetch Brands',
      onSuccess: (data) {
        final brands = data["data"] as List;
        log("Brands $brands");
        return brands.map((e) => Brand.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> followUnfollowBrand({
    required String brandId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction(
      functionName: 'follow-unfollow-brand',
      body: {"brandId": brandId},
      fallbackErrorMessage: 'Failed to update follow status',
      onSuccess: (data) =>
          data["message"] ?? "Successfully updated Follow Status",
    );
  }

  Future<Either<String, List<BrandMission>>> fetchBrandMissions({
    required String brandId,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<List<BrandMission>>(
      functionName: 'fetch-brand-missions',
      body: {"brandId": brandId},
      fallbackErrorMessage: 'Failed to Fetch Brand Mission',
      onSuccess: (data) {
        final mission = data["data"] as List;
        return mission.map((e) => BrandMission.fromJson(e)).toList();
      },
    );
  }

  Future<Either<String, String>> completeMission({
    required int missionId,
    required String userId,
    required String? image,
    required String text,
  }) async {
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken ?? "";
    final formData = FormData.fromMap({
      'missionId': missionId,
      'userId': userId,
      'evidenceImage': image != null
          ? await MultipartFile.fromFile(image, filename: image.split('/').last)
          : null,
      'evidenceText': text,
    });

    final response = await ApiService.instance!.postRequest(
      "functions/v1/complete-brand-mission",
      formData,
      accessToken: token,
      apiKey: dotenv.env["ANON_KEY"] ?? "",
    );

    Logger().d("Complete Brand Mission Response $response");

    if (response.responseSuccessful == true) {
      return Right(
        response.responseMessage ?? "Mission submitted successfully",
      );
    } else {
      return Left(
        response.responseMessage ?? "Failed to Complete Brand Mission",
      );
    }
  }
}
