part of 'profile_bloc.dart';

enum ProfileType {
  getProfile,
  updateProfile,
  updateCoverPic,
  updateLocation,
  deleteAccount,
  logout,
  saveFcmToken,
  deleteFcmToken,
  sendNotification,
}

@immutable
class ProfileState {
  final UserProfile profile;

  ProfileState({required this.profile});

  ProfileState copyWith({UserProfile? profile}) {
    return ProfileState(profile: profile ?? this.profile);
  }
}

class ProfileInitialState extends ProfileState {
  ProfileInitialState({required super.profile});
}

class ProfileLoadingState extends ProfileState {
  final ProfileType type;
  ProfileLoadingState({required this.type, required super.profile});
}

class ProfileFailureState extends ProfileState {
  final String message;
  final ProfileType type;
  ProfileFailureState({
    required this.message,
    required this.type,
    required super.profile,
  });
}

class ProfileSuccessState extends ProfileState {
  final String message;
  final ProfileType type;
  ProfileSuccessState({
    required this.message,
    required this.type,
    required super.profile,
  });
}
