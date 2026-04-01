import 'package:dartz/dartz.dart';

import '../model/response/brand_mission_model.dart';
import '../model/response/brand_model.dart';

abstract class BrandRepository {
  Future<Either<String, List<Brand>>> fetchBrands();

  Future<Either<String, String>> followUnfollowBrand({required String brandId});

  Future<Either<String, List<BrandMission>>> fetchBrandMissions({
    required String brandId,
  });

  Future<Either<String, String>> completeMission({
    required int missionId,
    required String userId,
    required String? image,
    required String text,
  });
}
