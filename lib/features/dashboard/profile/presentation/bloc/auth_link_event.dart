part of 'auth_link_bloc.dart';

@immutable
sealed class AuthLinkEvent {
  const AuthLinkEvent();
}

class AddPasswordEvent extends AuthLinkEvent {
  final String password;
  const AddPasswordEvent({required this.password});
}

class LinkGoogleEvent extends AuthLinkEvent {
  const LinkGoogleEvent();
}

class LinkAppleEvent extends AuthLinkEvent {
  const LinkAppleEvent();
}

class VerifyLinkEvent extends AuthLinkEvent {
  final String code;
  const VerifyLinkEvent({required this.code});
}

class UnlinkEvent extends AuthLinkEvent {
  final String provider;
  const UnlinkEvent({required this.provider});
}
