import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/streak_response.dart';
import '../../data/repository/streak_repository.dart';

part 'streak_event.dart';
part 'streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final StreakRepository repo;
  final supabase = Supabase.instance.client;

  StreakBloc({required this.repo})
    : super(StreakInitialState(streak: StreakResponse.empty())) {
    on<LoadStreaksEvent>(_loadStreak);
    on<CheckInEvent>(_checkIn);
  }

  Future<void> _loadStreak(LoadStreaksEvent event, Emitter emit) async {
    emit(
      StreakLoadingState(type: StreakType.fetchStreak, streak: state.streak),
    );

    final res = await repo.fetchStreak();

    Logger().d("Fetch Streak Response $res");

    res.fold(
      (err) => emit(
        StreakFailureState(
          type: StreakType.fetchStreak,
          message: err,
          streak: state.streak,
        ),
      ),
      (streak) {
        emit(state.copWith(streak: streak));

        emit(
          StreakSuccessState(
            type: StreakType.fetchStreak,
            message: "Successfully Retried Streaks",
            streak: streak,
          ),
        );
      },
    );
  }

  Future<void> _checkIn(CheckInEvent event, Emitter emit) async {
    emit(StreakLoadingState(type: StreakType.checkIn, streak: state.streak));

    final res = await repo.checkIn();

    res.fold(
      (err) => emit(
        StreakFailureState(
          type: StreakType.checkIn,
          message: err,
          streak: state.streak,
        ),
      ),
      (streak) {
        emit(state.copWith(streak: streak));

        emit(
          StreakSuccessState(
            type: StreakType.checkIn,
            message: "Successfully Retried Streaks",
            streak: streak,
          ),
        );
      },
    );
  }
}
