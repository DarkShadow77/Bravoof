part of 'verify_otp_cubit.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}


class Verifying extends VerifyOtpState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class VerifyOtpSuccessful extends VerifyOtpState {
  final AppBaseResponse appBaseResponse;

  VerifyOtpSuccessful(this.appBaseResponse);

  @override
  // TODO: implement props
  List<Object?> get props =>[appBaseResponse];
}
class OtpFailure extends VerifyOtpState {
  final String err;

  OtpFailure(this.err);

  @override
  // TODO: implement props
  List<Object?> get props =>[err];
}
