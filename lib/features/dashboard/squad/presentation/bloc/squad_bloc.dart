import 'package:bloc/bloc.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:meta/meta.dart';

import '../../data/repository/squad_repository.dart';

part 'squad_event.dart';
part 'squad_state.dart';

class SquadBloc extends Bloc<SquadEvent, SquadState> {
  final SquadRepository repo;
  SquadBloc({required this.repo}) : super(SquadInitialState(squads: [])) {
    on<FetchSquadsEvent>(_fetchSquads);
    on<JoinSquadEvent>(_joinSquad);
    on<LeaveSquadEvent>(_leaveSquad);
  }

  Future<void> _fetchSquads(FetchSquadsEvent event, Emitter emit) async {
    emit(SquadLoadingState(type: SquadType.fetchSquads, squads: state.squads));

    final res = await repo.fetchSquads(squadId: event.squadId);

    res.fold(
      (err) => emit(
        SquadErrorState(
          type: SquadType.fetchSquads,
          message: err,
          squads: state.squads,
        ),
      ),
      (squads) => emit(state.copWith(squads: squads)),
    );
  }

  Future<void> _joinSquad(JoinSquadEvent event, Emitter emit) async {
    emit(
      SquadLoadingState(
        squadId: event.squadId,
        type: SquadType.joinSquad,
        squads: state.squads,
      ),
    );

    final res = await repo.joinSquad(squadId: event.squadId);

    res.fold(
      (err) => emit(
        SquadErrorState(
          squadId: event.squadId,
          type: SquadType.joinSquad,
          message: err,
          squads: state.squads,
        ),
      ),
      (message) => emit(
        SquadSuccessState(
          squadId: event.squadId,
          type: SquadType.joinSquad,
          squads: state.squads,
          message: message,
        ),
      ),
    );
  }

  Future<void> _leaveSquad(LeaveSquadEvent event, Emitter emit) async {
    emit(
      SquadLoadingState(
        squadId: event.squadId,
        type: SquadType.leaveSquad,
        squads: state.squads,
      ),
    );

    final res = await repo.leaveSquad(squadId: event.squadId);

    res.fold(
      (err) => emit(
        SquadErrorState(
          squadId: event.squadId,
          type: SquadType.leaveSquad,
          message: err,
          squads: state.squads,
        ),
      ),
      (message) => emit(
        SquadSuccessState(
          squadId: event.squadId,
          type: SquadType.leaveSquad,
          squads: state.squads,
          message: message,
        ),
      ),
    );
  }
}
