part of 'jackpot_bloc.dart';

@immutable
sealed class JackpotState {}

final class JackpotInitialState extends JackpotState {}

class JackpotLoadingState extends JackpotState {
  JackpotLoadingState();
}

class JackpotErrorState extends JackpotState {
  final String message;
  JackpotErrorState({required this.message});
}

class JackpotSpinedState extends JackpotState {
  final String message;
  final Map<String, dynamic> result;
  JackpotSpinedState({required this.message, required this.result});
}
