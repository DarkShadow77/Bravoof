import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowva/features/common/model/app_base_response.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/features/onbaording/data/signup_repository/signup_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignupRepository _signupRepository = sl<SignupRepository>();
  UserCubit() : super(UserInitial());
  void signup({UserProfile? userProfile}) async {
    emit(UserLoading());

    final either = await _signupRepository.signUp(userProfile: userProfile!);
    print(either);
    either.fold((failure) {
      print("SignUp failure $failure");
      emit(UserFailure(failure.toString()));
    }, (user) => emit(UserSuccess(user)));
  }

  void signIn({UserProfile? userProfile}) async {
    emit(UserLoading());

    final either = await _signupRepository.signIn(userProfile: userProfile!);
    print(either);
    either.fold((failure) {
      print("SignUp failure $failure");
      emit(UserFailure(failure.toString()));
    }, (user) => emit(UserSuccess(user)));
  }

  void googleLogin() async {
    emit(UserLoading());

    final either = await _signupRepository.googleAuth();

    print("Google Auth: $either");
    either.fold(
      (failure) => emit(UserFailure(failure)),
      (response) => emit(UserSuccess(response)),
    );
  }

  void appleLogin() async {
    emit(UserLoading());

    final either = await _signupRepository.appleAuth();

    print("Apple Auth: $either");
    either.fold(
      (failure) => emit(UserFailure(failure)),
      (response) => emit(UserSuccess(response)),
    );
  }

  void forgotPassword({required String email}) async {
    emit(UserLoading());

    final either = await _signupRepository.forgotPassword(email: email);
    print(either);
    either.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (user) => emit(UserSuccess(user)),
    );
  }

  void resetPassword({required String password}) async {
    emit(UserLoading());

    final either = await _signupRepository.resetPassword(password: password);
    print(either);
    either.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (user) => emit(UserSuccess(user)),
    );
  }

  void updateProfile(UserProfile any) async {
    emit(Updating());

    final either = await _signupRepository.updateProfile(data: any);
    print(either);
    either.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (user) => emit(UserProfileSuccess(user)),
    );
  }

  void fetchUserProfile() async {
    emit(UserLoading());

    final either = await _signupRepository.fetchUserProfile();
    print(either);
    either.fold((failure) => emit(UserFailure(failure.toString())), (user) {
      emit(UserProfileSuccess(user));
    });
  }

  void uploadProfileImage(File? imageFile) async {
    emit(UploadLoading());

    final either = await _signupRepository.uploadProfileImage(imageFile!);
    print(either);
    either.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (url) => emit(UploadSuccess(url)),
    );
  }
}
