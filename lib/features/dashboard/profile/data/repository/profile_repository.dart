import 'dart:io';

import 'package:bravoo/features/dashboard/profile/data/model/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, UserProfile>> fetchUserProfile();
  Future<Either<String, UserProfile>> updateProfile({
    required UserProfile profile,
    File? imageFile,
  });
  Future<Either<String, void>> updateCoverPic({required File imageFile});
  Future<Either<String, void>> updateLocation();
  Future<Either<String, String>> deleteAccount({
    required String userId,
    required String reason,
  });
  Future<Either<String, String>> logUserLoginActivity({
    required String eventType,
  });
  Future<Either<String, String>> logUserLogoActivity({
    required String userId,
    required String logoString,
  });
  Future<Either<String, void>> saveFCMToken();
  Future<Either<String, void>> deleteFCMToken();
  Future<Either<String, void>> sendPushNotification();
}
