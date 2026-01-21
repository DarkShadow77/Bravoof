import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import '../../data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  final ProfileRepository repo;
  Logger logger = Logger();

  ProfileBloc({required this.repo})
    : super(ProfileInitialState(profile: UserProfile.empty())) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateCoverPicEvent>(_onUpdateCoverPic);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<SaveFCMTokenEvent>(_onSaveFCMToken);
    on<DeleteFCMTokenEvent>(_onDeleteFCMToken);
    on<SendNotificationEvent>(_onSendNotification);
    on<LogoutProfileEvent>(_onLogout);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(type: ProfileType.getProfile, profile: state.profile),
    );

    final response = await repo.fetchUserProfile();

    response.fold(
      (failure) {
        logger.e("Failed to get Profile $failure");
        emit(
          ProfileFailureState(
            type: ProfileType.getProfile,
            message: failure.toString(),
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.t("Get Profile Successful");

        //Update the state of the Profile
        emit(state.copyWith(profile: user));
        emit(
          ProfileSuccessState(
            type: ProfileType.getProfile,
            message: "Get Profile Successful",
            profile: user,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.updateProfile,
        profile: state.profile,
      ),
    );

    final response = await repo.updateProfile(
      profile: event.profile,
      imageFile: event.imageFile,
    );

    response.fold(
      (failure) {
        logger.e("Failed to Update Profile");
        emit(
          ProfileFailureState(
            type: ProfileType.updateProfile,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.t("Profile Updated  Successfully");
        emit(state.copyWith(profile: user));
        emit(
          ProfileSuccessState(
            type: ProfileType.updateProfile,
            message: "Profile updated successfully",
            profile: user,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateCoverPic(
    UpdateCoverPicEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.updateCoverPic,
        profile: state.profile,
      ),
    );

    final response = await repo.updateCoverPic(imageFile: event.imageFile);

    response.fold(
      (failure) {
        logger.e("Failed to Update Cover Pic");
        emit(
          ProfileFailureState(
            type: ProfileType.updateCoverPic,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.t("Cover Pic Updated  Successfully");

        add(GetProfileEvent());
        emit(
          ProfileSuccessState(
            type: ProfileType.updateCoverPic,
            message: "Cover Pic updated successfully",
            profile: state.profile,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.updateLocation,
        profile: state.profile,
      ),
    );

    final response = await repo.updateLocation();

    response.fold(
      (failure) {
        logger.e("Failed to Update Location");
        emit(
          ProfileFailureState(
            type: ProfileType.updateLocation,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.t("Location Updated Successfully");

        add(GetProfileEvent());
        emit(
          ProfileSuccessState(
            type: ProfileType.updateLocation,
            message: "Location updated successfully",
            profile: state.profile,
          ),
        );
      },
    );
  }

  Future<void> _onSaveFCMToken(
    SaveFCMTokenEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.saveFcmToken,
        profile: state.profile,
      ),
    );

    final response = await repo.saveFCMToken();

    response.fold(
      (failure) {
        logger.e("Failed to Save Fcm Token");
        emit(
          ProfileFailureState(
            type: ProfileType.saveFcmToken,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.w("Saved FCM Token Successfully");

        emit(
          ProfileSuccessState(
            type: ProfileType.saveFcmToken,
            message: "Saved FCM Token Successfully",
            profile: state.profile,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteFCMToken(
    DeleteFCMTokenEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.deleteFcmToken,
        profile: state.profile,
      ),
    );

    final response = await repo.deleteFCMToken();

    response.fold(
      (failure) {
        logger.e("Failed to Delete Fcm Token");
        emit(
          ProfileFailureState(
            type: ProfileType.deleteFcmToken,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.w("Deleted FCM Token Successfully");

        emit(
          ProfileSuccessState(
            type: ProfileType.deleteFcmToken,
            message: "Deleted FCM Token Successfully",
            profile: state.profile,
          ),
        );
      },
    );
  }

  Future<void> _onSendNotification(
    SendNotificationEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileLoadingState(
        type: ProfileType.sendNotification,
        profile: state.profile,
      ),
    );

    final response = await repo.sendPushNotification();

    response.fold(
      (failure) {
        logger.e("Failed to Send Notification");
        emit(
          ProfileFailureState(
            type: ProfileType.sendNotification,
            message: failure,
            profile: state.profile,
          ),
        );
      },
      (user) {
        logger.w("Sent Notification Successfully");

        emit(
          ProfileSuccessState(
            type: ProfileType.sendNotification,
            message: "Sent Notification Successfully",
            profile: state.profile,
          ),
        );
      },
    );
  }

  Future<void> _onLogout(
    LogoutProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    add(DeleteFCMTokenEvent());
    logger.w("🚪 Logging out user");

    // 🔥 Clear persisted state for this bloc
    await clear();

    emit(
      ProfileInitialState(
        profile: UserProfile.empty(), // empty profile
      ),
    );
  }

  // 🔹 HydratedBloc methods
  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      final profile = UserProfile.fromJson(json);

      Logger().f("Restored from cache ${profile.email} ${profile.name}");
      return ProfileSuccessState(
        type: ProfileType.getProfile,
        message: "Restored from cache",
        profile: profile,
      );
    } catch (e) {
      Logger().e("Failed to restore ProfileBloc fromJson: $e");
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    try {
      return (state.profile).toJson();
    } catch (e) {
      Logger().e("Failed to persist ProfileBloc toJson: $e");
      return null;
    }
  }
}
