part of 'user_cubit.dart';

@immutable
sealed class UserState extends Equatable{}

final class UserInitial extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoading extends UserState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class UploadLoading extends UserState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class Updating extends UserState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UserSuccess extends UserState {
  final AppBaseResponse appBaseResponse;

  UserSuccess(this.appBaseResponse);

  @override
  // TODO: implement props
  List<Object?> get props =>[appBaseResponse];
}
class UserProfileSuccess extends UserState {
  final UserProfile userProfile;

  UserProfileSuccess(this.userProfile);

  @override
  // TODO: implement props
  List<Object?> get props =>[userProfile];
}
class UploadSuccess extends UserState {
  final String imageUrl;

  UploadSuccess(this.imageUrl);

  @override
  // TODO: implement props
  List<Object?> get props =>[imageUrl];
}

class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props =>[error];
}


abstract class UserEvent {}

class LoginRequested extends UserEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}
