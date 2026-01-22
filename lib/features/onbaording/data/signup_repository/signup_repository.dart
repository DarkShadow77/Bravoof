import 'package:Bravoo/features/common/model/app_base_response.dart';
import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class SignupRepository {
  Future<Either<String, AppBaseResponse>> signUp({UserProfile userProfile});
  Future<Either<String, Map<String, dynamic>>> verifyReferralCode({
    required String code,
  });
  Future<Either<String, AppBaseResponse>> forgotPassword({
    required String email,
  });
  Future<Either<String, AppBaseResponse>> resetPassword({
    required String password,
  });
  Future<Either<String, AppBaseResponse>> signIn({UserProfile userProfile});
  Future<Either<String, AppBaseResponse>> googleAuth();
  Future<Either<String, AppBaseResponse>> appleAuth();
}
