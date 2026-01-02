import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../session/session_manager.dart';
import '../../../dashboard/earn/data/models/mission_res.dart';
import '../../data/repository/growth_mission_repository.dart';

part 'growth_mission_event.dart';
part 'growth_mission_state.dart';

class GrowthMissionBloc extends Bloc<GrowthMissionEvent, GrowthMissionState> {
  final GrowthMissionRepository repo;
  SessionManager session = SessionManager();

  GrowthMissionBloc({required this.repo})
    : super(GrowthMissionInitialState(missions: [])) {
    on<LoadGrowthMission>(_loadMission);
    on<CompleteGrowthMission>(_completeMission);
  }

  Future<void> _loadMission(LoadGrowthMission event, Emitter emit) async {
    if (state.missions.isEmpty)
      emit(
        GrowthMissionLoadingState(
          type: GrowthMissionType.fetchMission,
          missions: state.missions,
        ),
      );

    final missionRes = await repo.fetchGrowthMission();

    missionRes.fold(
      (err) => emit(
        GrowthMissionFailureState(
          type: GrowthMissionType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) {
        emit(state.copWith(missions: missions));
        emit(
          GrowthMissionSuccessState(
            type: GrowthMissionType.fetchMission,
            missions: missions,
            message: "Fetched Missions successfully",
          ),
        );
      },
    );
  }

  Future<void> _completeMission(
    CompleteGrowthMission event,
    Emitter emit,
  ) async {
    emit(
      GrowthMissionLoadingState(
        type: GrowthMissionType.completeMission,
        missions: state.missions,
      ),
    );

    final res = await repo.completeMission(mission: event.mission);

    res.fold(
      (err) => emit(
        GrowthMissionFailureState(
          type: GrowthMissionType.completeMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        GrowthMissionSuccessState(
          type: GrowthMissionType.completeMission,
          missions: state.missions,
          message: "Mission completed successfully",
        ),
      ),
    );
  }
}
