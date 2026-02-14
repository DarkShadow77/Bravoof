part of 'auth_bloc.dart';

enum AuthType {
  checkEmail,
  signIn,
  googleAuth,
  appleAuth,
  sendOtp,
  resendOtp,
  completeOnboarding,
  forgotPassword,
  resendResetOtp,
  verifyForgotPasswordOtp,
  resetPassword,
  verifyReferralCode,
}

@immutable
sealed class AuthState {
  AuthState();
}

class AuthInitialState extends AuthState {
  AuthInitialState();
}

class AuthLoadingState extends AuthState {
  final AuthType type;
  AuthLoadingState({required this.type});
}

class AuthFailureState extends AuthState {
  final String message;
  final AuthType type;
  AuthFailureState({required this.message, required this.type});
}

class AuthSuccessState extends AuthState {
  final AppBaseResponse response;
  final AuthType type;
  AuthSuccessState({required this.response, required this.type});
}

class AuthTextSuccessState extends AuthState {
  final String message;
  final AuthType type;
  AuthTextSuccessState({required this.message, required this.type});
}

class EmailCheckResponseState extends AuthState {
  final EmailCheckResult response;
  EmailCheckResponseState({required this.response});
}

class ReferralResponseState extends AuthState {
  final ReferralResult response;
  ReferralResponseState({required this.response});
}
