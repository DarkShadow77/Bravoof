import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/mission_status_enum.dart';
import '../../data/model/new_social_mission_model.dart';
import '../../data/repository/new_social_mission_repository.dart';

part 'new_social_mission_event.dart';
part 'new_social_mission_state.dart';

class NewSocialMissionBloc
    extends Bloc<NewSocialMissionEvent, NewSocialMissionState> {
  final NewSocialMissionRepository repo;
  final supabase = Supabase.instance.client;

  NewSocialMissionBloc({required this.repo})
    : super(NewSocialMissionInitial(hasJoined: [], missions: [])) {
    on<LoadNewSocialMission>(_loadMission);
    on<CompleteNewSocialMission>(_completeMission);
    on<CheckCompletedStatus>(_checkCompletedStatus);
  }

  Future<void> _loadMission(LoadNewSocialMission event, Emitter emit) async {
    emit(
      NewSocialMissionLoading(
        type: NewSocialMissionType.fetchMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchNewSocialMission();

    missionRes.fold(
      (err) => emit(
        NewSocialMissionError(
          type: NewSocialMissionType.fetchMission,
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
    CompleteNewSocialMission event,
    Emitter emit,
  ) async {
    emit(
      NewSocialMissionLoading(
        missionId: event.missionId,
        type: NewSocialMissionType.completeMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final res = await repo.completeMission(
      missionId: event.missionId,
      userId: supabase.auth.currentUser!.id,
      imageUrl: event.imageUrl,
      text: event.text,
    );

    res.fold(
      (err) => emit(
        NewSocialMissionError(
          missionId: event.missionId,
          type: NewSocialMissionType.completeMission,
          message: err,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        NewSocialMissionJoined(
          missionId: event.missionId,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
    );
  }
}
