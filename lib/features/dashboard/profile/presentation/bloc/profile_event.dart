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

class UpdateLocationEvent extends ProfileEvent {
  UpdateLocationEvent();
}

class DeleteAccountEvent extends ProfileEvent {
  final String reason;
  const DeleteAccountEvent({required this.reason});
}

class LogUserLoginActivityEvent extends ProfileEvent {
  final String eventType;
  const LogUserLoginActivityEvent({required this.eventType});
}

class LogoutProfileEvent extends ProfileEvent {}

class SaveFCMTokenEvent extends ProfileEvent {
  const SaveFCMTokenEvent();
}

class DeleteFCMTokenEvent extends ProfileEvent {
  const DeleteFCMTokenEvent();
}

class SendNotificationEvent extends ProfileEvent {
  const SendNotificationEvent();
}
