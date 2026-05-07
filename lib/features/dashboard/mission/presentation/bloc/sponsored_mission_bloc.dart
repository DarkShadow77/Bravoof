import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/mission_status_enum.dart';
import '../../data/model/sponsored_mission_model.dart';
import '../../data/repository/sponsored_mission_repository.dart';

part 'sponsored_mission_event.dart';
part 'sponsored_mission_state.dart';

class SponsoredMissionBloc
    extends Bloc<SponsoredMissionEvent, SponsoredMissionState> {
  final SponsoredMissionRepository repo;
  final supabase = Supabase.instance.client;

  SponsoredMissionBloc({required this.repo})
    : super(SponsoredMissionInitial(hasJoined: [], missions: [])) {
    on<LoadSponsoredMission>(_loadMission);
    on<CompleteSponsoredMission>(_completeMission);
    on<CheckCompletedStatus>(_checkCompletedStatus);
  }

  Future<void> _loadMission(LoadSponsoredMission event, Emitter emit) async {
    emit(
      SponsoredMissionLoading(
        type: SponsoredMissionType.fetchMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchSponsoredMission();

    missionRes.fold(
      (err) => emit(
        SponsoredMissionError(
          type: SponsoredMissionType.fetchMission,
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
      userId: supabase.auth.currentUser!.id,
    );

    joined.fold((err) {}, (data) {
      final updatedHasJoined = List<MissionStatus>.from(state.hasJoined);

      updatedHasJoined[event.index] = data;

      emit(state.copWith(hasJoined: updatedHasJoined));
    });
  }

  Future<void> _completeMission(
    CompleteSponsoredMission event,
    Emitter emit,
  ) async {
    emit(
      SponsoredMissionLoading(
        missionId: event.missionId,
        type: SponsoredMissionType.completeMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final res = await repo.completeMission(
      missionId: event.missionId,
      image: event.image,
      text: event.text,
      isVideo: event.isVideo,
    );

    res.fold(
      (err) => emit(
        SponsoredMissionError(
          missionId: event.missionId,
          type: SponsoredMissionType.completeMission,
          message: err,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        SponsoredMissionJoined(
          missionId: event.missionId,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
    );
  }
}
