import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/jackpot_repository.dart';

part 'jackpot_event.dart';
part 'jackpot_state.dart';

class JackpotBloc extends Bloc<JackpotEvent, JackpotState> {
  final JackpotRepository repo;

  final supabase = Supabase.instance.client;

  JackpotBloc({required this.repo}) : super(JackpotInitialState()) {
    on<SpinJackpotEvent>(_spinJackpot);
  }

  Future<void> _spinJackpot(SpinJackpotEvent event, Emitter emit) async {
    emit(JackpotLoadingState());

    final res = await repo.spinJackpot(userId: supabase.auth.currentUser!.id);

    Logger().d("Jackpot Spined: $res");
    res.fold(
      (err) => emit(JackpotErrorState(message: err)),
      (res) => emit(
        JackpotSpinedState(message: "Jackpot Spin Successfully", result: res),
      ),
    );
  }
}
