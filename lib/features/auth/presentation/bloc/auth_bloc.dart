import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/model/app_base_response.dart';
import '../../data/model/email_check_model.dart';
import '../../data/model/enums.dart';
import '../../data/model/referral_response_model.dart';
import '../../data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  final supabase = Supabase.instance.client;

  AuthBloc({required this.repo}) : super(AuthInitialState()) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<SignInEvent>(_onSignIn);
    on<GoogleAuthEvent>(_onGoogleAuth);
    on<AppleAuthEvent>(_onAppleAuth);
    on<SendOtpEvent>(_onSendOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResendResetOtpEvent>(_onResendResetOtp);
    on<VerifyForgotPasswordEvent>(_onVerifyForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyReferralCodeEvent>(_onVerifyReferralCode);
  }

  Future<void> _onCheckEmail(
    CheckEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.checkEmail));

    final response = await repo.checkEmail(
      email: event.email,
      context: event.context,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.checkEmail,
          message: failure.toString(),
        ),
      ),
      (response) => emit(EmailCheckResponseState(response: response)),
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(type: AuthType.signIn));

    final response = await repo.signIn(
      email: event.email,
      password: event.password,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(type: AuthType.signIn, message: failure.toString()),
      ),
      (response) =>
          emit(AuthSuccessState(type: AuthType.signIn, response: response)),
    );
  }

  Future<void> _onGoogleAuth(
    GoogleAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.googleAuth));

    final response = await repo.googleAuth();

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.googleAuth,
          message: failure.toString(),
        ),
      ),
      (response) =>
          emit(AuthSuccessState(type: AuthType.googleAuth, response: response)),
    );
  }

  Future<void> _onAppleAuth(
    AppleAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.appleAuth));

    final response = await repo.appleAuth();

    response.fold(
      (failure) => emit(
        AuthFailureState(type: AuthType.appleAuth, message: failure.toString()),
      ),
      (response) =>
          emit(AuthSuccessState(type: AuthType.appleAuth, response: response)),
    );
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(type: AuthType.sendOtp));

    final response = await repo.sendOtp(
      email: event.email,
      context: OtpContext.signUp,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(type: AuthType.sendOtp, message: failure.toString()),
      ),
      (message) =>
          emit(AuthTextSuccessState(type: AuthType.sendOtp, message: message)),
    );
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.resendOtp));

    final response = await repo.resendOtp(
      email: event.email,
      context: OtpContext.signUp,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(type: AuthType.resendOtp, message: failure.toString()),
      ),
      (message) => emit(
        AuthTextSuccessState(type: AuthType.resendOtp, message: message),
      ),
    );
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.completeOnboarding));

    final response = await repo.completeOnboarding(
      otp: event.otp,
      profile: event.profile,
      imageFile: event.imageFile,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.completeOnboarding,
          message: failure.toString(),
        ),
      ),
      (response) => emit(
        AuthSuccessState(type: AuthType.completeOnboarding, response: response),
      ),
    );
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.forgotPassword));

    final response = await repo.forgotPassword(email: event.email);

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.forgotPassword,
          message: failure.toString(),
        ),
      ),
      (message) => emit(
        AuthTextSuccessState(type: AuthType.forgotPassword, message: message),
      ),
    );
  }

  Future<void> _onResendResetOtp(
    ResendResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.resendResetOtp));

    final response = await repo.resendOtp(
      email: event.email,
      context: OtpContext.forgotPassword,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.resendResetOtp,
          message: failure.toString(),
        ),
      ),
      (message) => emit(
        AuthTextSuccessState(type: AuthType.resendResetOtp, message: message),
      ),
    );
  }

  Future<void> _onVerifyForgotPassword(
    VerifyForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.verifyForgotPasswordOtp));

    final response = await repo.verifyForgotPasswordOtp(
      email: event.email,
      otp: event.otp,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.verifyForgotPasswordOtp,
          message: failure.toString(),
        ),
      ),
      (message) => emit(
        AuthTextSuccessState(
          type: AuthType.verifyForgotPasswordOtp,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.resetPassword));

    final response = await repo.resetPassword(
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.resetPassword,
          message: failure.toString(),
        ),
      ),
      (response) => emit(
        AuthSuccessState(type: AuthType.resetPassword, response: response),
      ),
    );
  }

  Future<void> _onVerifyReferralCode(
    VerifyReferralCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState(type: AuthType.verifyReferralCode));

    final response = await repo.verifyReferralCode(code: event.code);

    response.fold(
      (failure) => emit(
        AuthFailureState(
          type: AuthType.verifyReferralCode,
          message: failure.toString(),
        ),
      ),
      (response) => emit(ReferralResponseState(response: response)),
    );
  }
}
