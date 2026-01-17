import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<String, UserProfile>> fetchUserProfile();
  Future<Either<String, UserProfile>> updateProfile({
    required UserProfile profile,
    File? imageFile,
  });
  Future<Either<String, void>> updateCoverPic({required File imageFile});
  Future<Either<String, void>> updateLocation();
}
