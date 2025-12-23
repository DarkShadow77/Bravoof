import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/features/onbaording/data/signup_repository/signup_repository.dart';
import 'package:flowva/session/session_manager.dart';

import '../../../../core/di/service_locator.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignupRepository _signupRepository = sl<SignupRepository>();
  UserCubit() : super(UserInitial(userProfile: UserProfile()));

  void signup({UserProfile? userProfile}) async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.signUp(userProfile: userProfile!);
    print(either);
    either.fold((failure) {
      print("SignUp failure $failure");
      emit(UserFailure(failure.toString(), userProfile: state.userProfile));
    }, (user) => emit(UserSuccess(user, userProfile: state.userProfile)));
  }

  void verifyReferralCode({required String code}) async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.verifyReferralCode(code: code);
    log("Verify ReferralCode: $either");
    either.fold((failure) {
      emit(UserFailure(failure.toString(), userProfile: state.userProfile));
    }, (user) => emit(ReferralCodeVerified(userProfile: state.userProfile)));
  }

  void signIn({UserProfile? userProfile}) async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.signIn(userProfile: userProfile!);
    print(either);
    either.fold((failure) {
      print("SignUp failure $failure");
      emit(UserFailure(failure.toString(), userProfile: state.userProfile));
    }, (user) => emit(UserSuccess(user, userProfile: state.userProfile)));
  }

  void googleLogin() async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.googleAuth();

    print("Google Auth: $either");
    either.fold(
      (failure) => emit(UserFailure(failure, userProfile: state.userProfile)),
      (response) => emit(UserSuccess(response, userProfile: state.userProfile)),
    );
  }

  void appleLogin() async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.appleAuth();

    print("Apple Auth: $either");
    either.fold(
      (failure) => emit(UserFailure(failure, userProfile: state.userProfile)),
      (response) => emit(UserSuccess(response, userProfile: state.userProfile)),
    );
  }

  void forgotPassword({required String email}) async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.forgotPassword(email: email);
    print(either);
    either.fold(
      (failure) =>
          emit(UserFailure(failure.toString(), userProfile: state.userProfile)),
      (user) => emit(UserSuccess(user, userProfile: state.userProfile)),
    );
  }

  void resetPassword({required String password}) async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.resetPassword(password: password);
    print(either);
    either.fold(
      (failure) =>
          emit(UserFailure(failure.toString(), userProfile: state.userProfile)),
      (user) => emit(UserSuccess(user, userProfile: state.userProfile)),
    );
  }

  void updateProfile(UserProfile any) async {
    emit(Updating(userProfile: state.userProfile));

    final either = await _signupRepository.updateProfile(data: any);
    print(either);
    either.fold(
      (failure) =>
          emit(UserFailure(failure.toString(), userProfile: state.userProfile)),
      (user) {
        SessionManager().pointsVal = user.totalPoints ?? 0;
        SessionManager().jackpotVal = user.spins ?? 0;
        emit(state.copyWith(userProfile: user));
        emit(UserProfileSuccess(userProfile: user));
      },
    );
  }

  void fetchUserProfile() async {
    emit(UserLoading(userProfile: state.userProfile));

    final either = await _signupRepository.fetchUserProfile();
    print(either);
    either.fold(
      (failure) =>
          emit(UserFailure(failure.toString(), userProfile: state.userProfile)),
      (user) {
        SessionManager().pointsVal = user.totalPoints ?? 0;
        SessionManager().jackpotVal = user.spins ?? 0;
        emit(state.copyWith(userProfile: user));
        emit(UserProfileSuccess(userProfile: user));
      },
    );
  }

  void updateUserProfile() async {
    final either = await _signupRepository.fetchUserProfile();
    print(either);
    either.fold((failure) => log(failure.toString()), (user) {
      SessionManager().pointsVal = user.totalPoints ?? 0;
      SessionManager().jackpotVal = user.spins ?? 0;
      emit(state.copyWith(userProfile: user));
      emit(UserProfileSuccess(userProfile: user));
    });
  }

  void uploadProfileImage(File? imageFile) async {
    emit(UploadLoading(userProfile: state.userProfile));

    final either = await _signupRepository.uploadProfileImage(imageFile!);
    print(either);
    either.fold(
      (failure) =>
          emit(UserFailure(failure.toString(), userProfile: state.userProfile)),
      (url) => emit(UploadSuccess(url, userProfile: state.userProfile)),
    );
  }
}
