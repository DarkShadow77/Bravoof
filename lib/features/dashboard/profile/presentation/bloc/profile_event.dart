part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final UserProfile profile;
  final File? imageFile;

  UpdateProfileEvent({required this.profile, this.imageFile});
}

class UpdateCoverPicEvent extends ProfileEvent {
  final File imageFile;

  UpdateCoverPicEvent({required this.imageFile});
}

class LogoutProfileEvent extends ProfileEvent {}
