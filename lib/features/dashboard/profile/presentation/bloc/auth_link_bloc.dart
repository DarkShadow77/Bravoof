import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/oauth_link_initiate_response.dart';
import '../../data/repository/auth_link_repository.dart';

part 'auth_link_event.dart';
part 'auth_link_state.dart';

class AuthLinkBloc extends Bloc<AuthLinkEvent, AuthLinkState> {
  final AuthLinkRepository repo;

  final supabase = Supabase.instance.client;

  AuthLinkBloc({required this.repo}) : super(AuthLinkInitialState()) {
    on<AddPasswordEvent>(_onAddPassword);
    on<LinkGoogleEvent>(_onLinkGoogle);
    on<LinkAppleEvent>(_onLinkApple);
    on<VerifyLinkEvent>(_onVerifyLink);
    on<UnlinkEvent>(_onUnlink);
  }

  Future<void> _onAddPassword(
    AddPasswordEvent event,
    Emitter<AuthLinkState> emit,
  ) async {
    emit(AuthLinkLoadingState(type: AuthLinkType.addPassword));

    final response = await repo.addPassword(password: event.password);

    response.fold(
      (failure) => emit(
        AuthLinkFailureState(
          type: AuthLinkType.addPassword,
          message: failure.toString(),
        ),
      ),
      (message) => emit(
        AuthLinkSuccessState(type: AuthLinkType.addPassword, message: message),
      ),
    );
  }

  Future<void> _onLinkGoogle(
    LinkGoogleEvent event,
    Emitter<AuthLinkState> emit,
  ) async {
    emit(AuthLinkLoadingState(type: AuthLinkType.linkGoogle));

    final result = await repo.initiateGoogleLink();

    result.fold(
      (failure) => emit(
        AuthLinkFailureState(
          type: AuthLinkType.linkGoogle,
          message: failure.toString(),
        ),
      ),
      (response) => emit(
        AuthLinkOAuthResponseState(
          type: AuthLinkType.linkGoogle,
          response: response,
        ),
      ),
    );
  }

  Future<void> _onLinkApple(
    LinkAppleEvent event,
    Emitter<AuthLinkState> emit,
  ) async {
    emit(AuthLinkLoadingState(type: AuthLinkType.linkApple));

    final result = await repo.initiateAppleLink();

    result.fold(
      (failure) => emit(
        AuthLinkFailureState(
          type: AuthLinkType.linkApple,
          message: failure.toString(),
        ),
      ),
      (response) => emit(
        AuthLinkOAuthResponseState(
          type: AuthLinkType.linkApple,
          response: response,
        ),
      ),
    );
  }

  Future<void> _onVerifyLink(
    VerifyLinkEvent event,
    Emitter<AuthLinkState> emit,
  ) async {
    emit(AuthLinkLoadingState(type: AuthLinkType.verifyLink));

    final result = await repo.verifyAndCompleteLink(
      verificationCode: event.code,
    );

    result.fold(
      (failure) => emit(
        AuthLinkFailureState(
          type: AuthLinkType.verifyLink,
          message: failure.toString(),
        ),
      ),
      (response) => emit(
        AuthLinkVerifyResponseState(
          type: AuthLinkType.verifyLink,
          response: response,
        ),
      ),
    );
  }

  Future<void> _onUnlink(UnlinkEvent event, Emitter<AuthLinkState> emit) async {
    emit(AuthLinkLoadingState(type: AuthLinkType.unlinkProvider));

    final result = await repo.unlinkProvider(provider: event.provider);

    result.fold(
      (failure) => emit(
        AuthLinkFailureState(
          type: AuthLinkType.unlinkProvider,
          message: failure.toString(),
        ),
      ),
      (message) => emit(
        AuthLinkSuccessState(
          type: AuthLinkType.unlinkProvider,
          message: message,
        ),
      ),
    );
  }
}
