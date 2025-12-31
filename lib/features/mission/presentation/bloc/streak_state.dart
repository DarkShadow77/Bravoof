part of 'streak_bloc.dart';

enum StreakType { fetchStreak, checkIn }

@immutable
class StreakState {
  final StreakResponse streak;

  StreakState({required this.streak});

  StreakState copWith({StreakResponse? streak}) {
    return StreakState(streak: streak ?? this.streak);
  }
}

class StreakInitialState extends StreakState {
  StreakInitialState({required super.streak});
}

class StreakLoadingState extends StreakState {
  final StreakType type;
  StreakLoadingState({required this.type, required super.streak});
}

class StreakSuccessState extends StreakState {
  final String message;
  final StreakType type;
  StreakSuccessState({
    required this.message,
    required this.type,
    required super.streak,
  });
}

class StreakFailureState extends StreakState {
  final String message;
  final StreakType type;
  StreakFailureState({
    required this.message,
    required this.type,
    required super.streak,
  });
}
