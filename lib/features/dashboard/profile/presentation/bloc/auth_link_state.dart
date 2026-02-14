part of 'auth_link_bloc.dart';

enum AuthLinkType {
  addPassword,
  linkGoogle,
  linkApple,
  verifyLink,
  unlinkProvider,
}

@immutable
sealed class AuthLinkState {
  AuthLinkState();
}

class AuthLinkInitialState extends AuthLinkState {
  AuthLinkInitialState();
}

class AuthLinkLoadingState extends AuthLinkState {
  final AuthLinkType type;
  AuthLinkLoadingState({required this.type});
}

class AuthLinkFailureState extends AuthLinkState {
  final String message;
  final AuthLinkType type;
  AuthLinkFailureState({required this.message, required this.type});
}

class AuthLinkSuccessState extends AuthLinkState {
  final String message;
  final AuthLinkType type;
  AuthLinkSuccessState({required this.message, required this.type});
}

class AuthLinkOAuthResponseState extends AuthLinkState {
  final OAuthLinkInitiateResponse response;
  final AuthLinkType type;
  AuthLinkOAuthResponseState({required this.response, required this.type});
}

class AuthLinkVerifyResponseState extends AuthLinkState {
  final OAuthLinkVerifyResponse response;
  final AuthLinkType type;
  AuthLinkVerifyResponseState({required this.response, required this.type});
}
