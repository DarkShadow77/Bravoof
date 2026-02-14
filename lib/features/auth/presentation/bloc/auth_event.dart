part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

class CheckEmailEvent extends AuthEvent {
  final String email;
  final EmailCheckContext context;
  const CheckEmailEvent({required this.email, required this.context});
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});
}

class GoogleAuthEvent extends AuthEvent {
  const GoogleAuthEvent();
}

class AppleAuthEvent extends AuthEvent {
  const AppleAuthEvent();
}

class SendOtpEvent extends AuthEvent {
  final String email;
  const SendOtpEvent({required this.email});
}

class ResendOtpEvent extends AuthEvent {
  final String email;
  const ResendOtpEvent({required this.email});
}

class CompleteOnboardingEvent extends AuthEvent {
  final String otp;
  final Map<String, dynamic> profile;
  final File imageFile;

  const CompleteOnboardingEvent({
    required this.otp,
    required this.profile,
    required this.imageFile,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  const ForgotPasswordEvent({required this.email});
}

class ResendResetOtpEvent extends AuthEvent {
  final String email;
  const ResendResetOtpEvent({required this.email});
}

class VerifyForgotPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyForgotPasswordEvent({required this.email, required this.otp});
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;
  const ResetPasswordEvent({
    required this.password,
    required this.confirmPassword,
  });
}

class VerifyReferralCodeEvent extends AuthEvent {
  final String code;
  const VerifyReferralCodeEvent({required this.code});
}
