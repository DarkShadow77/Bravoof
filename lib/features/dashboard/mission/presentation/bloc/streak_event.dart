part of 'streak_bloc.dart';

@immutable
abstract class StreakEvent {}

class LoadStreaksEvent extends StreakEvent {
  LoadStreaksEvent();
}

class CheckInEvent extends StreakEvent {
  CheckInEvent();
}
