import 'package:bloc/bloc.dart';
import 'package:Bravoo/features/common/model/app_base_response.dart';
import 'package:Bravoo/features/otp/data/repository/verify_otp_repository.dart';
import 'package:meta/meta.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());
  final verifyOtpRepository = VerifyOtpRepository();
  void verifyOtp({required String otp}) async {
    emit(Verifying());

    final either = await verifyOtpRepository.verifyOtp(otp: otp);
    print("Verify Otp Response: $either");
    either.fold(
      (failure) => emit(OtpFailure(failure.toString())),
      (otp) => emit(VerifyOtpSuccessful(otp)),
    );
  }

  void resendOtp({required String email}) async {
    final result = await verifyOtpRepository.resendOtp(email);

    result.fold((error) => emit(OtpFailure(error)), (otp) {});
  }

  void verifyResetPasswordOtp({required Map<String, dynamic> otp}) async {
    emit(Verifying());

    final either = await verifyOtpRepository.verifyResetPasswordOtp(otp: otp);
    print(either);
    either.fold(
      (failure) => emit(OtpFailure(failure.toString())),
      (otp) => emit(VerifyOtpSuccessful(otp)),
    );
  }
}
