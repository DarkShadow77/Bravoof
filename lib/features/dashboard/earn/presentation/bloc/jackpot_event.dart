part of 'jackpot_bloc.dart';

@immutable
sealed class JackpotEvent {}

class SpinJackpotEvent extends JackpotEvent {}
