part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserProfile userProfile;
  const UserState({required this.userProfile});

  UserState copyWith({UserProfile? userProfile}) {
    return UserState(userProfile: userProfile ?? this.userProfile);
  }

  @override
  List<Object?> get props => [userProfile];
}

final class UserInitial extends UserState {
  UserInitial({required super.userProfile});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  UserLoading({required super.userProfile});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserSuccess extends UserState {
  final AppBaseResponse appBaseResponse;

  UserSuccess(this.appBaseResponse, {required super.userProfile});

  @override
  List<Object?> get props => [appBaseResponse];
}

class ReferralCodeVerified extends UserState {
  // final AppBaseResponse appBaseResponse;

  ReferralCodeVerified({required super.userProfile});

  @override
  List<Object?> get props => [];
}

class UserFailure extends UserState {
  final String error;

  UserFailure(this.error, {required super.userProfile});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

abstract class UserEvent {}

class LoginRequested extends UserEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}
