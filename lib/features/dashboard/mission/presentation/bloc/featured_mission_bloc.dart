import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../session/session_manager.dart';
import '../../data/model/featured_mission_model.dart';
import '../../data/model/mission_status_enum.dart';
import '../../data/repository/featured_mission_repository.dart';

part 'featured_mission_event.dart';
part 'featured_mission_state.dart';

class FeaturedMissionBloc
    extends Bloc<FeaturedMissionEvent, FeaturedMissionState> {
  final FeaturedMissionRepository repo;
  SessionManager session = SessionManager();

  FeaturedMissionBloc({required this.repo})
    : super(FeaturedMissionInitial(hasJoined: [], missions: [])) {
    on<LoadFeaturedMission>(_loadMission);
    on<CompleteFeaturedMission>(_completeMission);
    on<CheckCompletedStatus>(_checkCompletedStatus);
  }

  Future<void> _loadMission(LoadFeaturedMission event, Emitter emit) async {
    emit(
      FeaturedMissionLoading(
        type: FeaturedMissionType.fetchMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchFeaturedMission();

    missionRes.fold(
      (err) => emit(
        FeaturedMissionError(
          type: FeaturedMissionType.fetchMission,
          message: err,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
      (missions) {
        // 🔹 Ensure hasJoined matches missions length
        final joinedList = List<MissionStatus>.filled(
          missions.length,
          MissionStatus.notJoined,
        );

        emit(state.copWith(missions: missions, hasJoined: joinedList));

        // 🔹 Now check each mission status
        for (int i = 0; i < missions.length; i++) {
          add(CheckCompletedStatus(missionId: missions[i].id, index: i));
        }
      },
    );
  }

  Future<void> _checkCompletedStatus(
    CheckCompletedStatus event,
    Emitter emit,
  ) async {
    final joined = await repo.hasJoined(
      missionId: event.missionId,
      userId: session.userIdVal,
    );

    // 🔹 Clone list (VERY important)
    final updatedHasJoined = List<MissionStatus>.from(state.hasJoined);

    updatedHasJoined[event.index] = joined;

    emit(state.copWith(hasJoined: updatedHasJoined));
  }

  Future<void> _completeMission(
    CompleteFeaturedMission event,
    Emitter emit,
  ) async {
    emit(
      FeaturedMissionLoading(
        missionId: event.missionId,
        type: FeaturedMissionType.completeMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final res = await repo.completeMission(
      missionId: event.missionId,
      userId: session.userIdVal,
      text: event.text,
      imageUrl: event.imageUrl,
    );

    res.fold(
      (err) => emit(
        FeaturedMissionError(
          missionId: event.missionId,
          type: FeaturedMissionType.completeMission,
          message: err,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        FeaturedMissionJoined(
          missionId: event.missionId,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
    );
  }
}
