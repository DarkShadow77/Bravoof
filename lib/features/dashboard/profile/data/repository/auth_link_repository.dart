import 'package:dartz/dartz.dart';

import '../model/oauth_link_initiate_response.dart';

abstract class AuthLinkRepository {
  Future<Either<String, String>> addPassword({required String password});
  Future<Either<String, OAuthLinkInitiateResponse>> initiateGoogleLink();
  Future<Either<String, OAuthLinkInitiateResponse>> initiateAppleLink();
  Future<Either<String, OAuthLinkVerifyResponse>> verifyAndCompleteLink({
    required String verificationCode,
  });
  Future<Either<String, String>> unlinkProvider({required String provider});
  Future<void> signOutGoogle();
}
