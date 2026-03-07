import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/mission_status_enum.dart';
import '../../data/model/social_mission_model.dart';
import '../../data/repository/social_mission_repository.dart';

part 'social_mission_event.dart';
part 'social_mission_state.dart';

class SocialMissionBloc extends Bloc<SocialMissionEvent, SocialMissionState> {
  final SocialMissionRepository repo;
  final supabase = Supabase.instance.client;

  SocialMissionBloc({required this.repo})
    : super(SocialMissionInitial(hasJoined: [], missions: [])) {
    on<LoadSocialMission>(_loadMission);
    on<CompleteSocialMission>(_completeMission);
    on<CheckCompletedStatus>(_checkCompletedStatus);
  }

  Future<void> _loadMission(LoadSocialMission event, Emitter emit) async {
    emit(
      SocialMissionLoading(
        type: SocialMissionType.fetchMission,
        hasJoined: state.hasJoined,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchSocialMission();

    missionRes.fold(
      (err) => emit(
        SocialMissionError(
          type: SocialMissionType.fetchMission,
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
    CompleteSocialMission event,
    Emitter emit,
  ) async {
    emit(
      SocialMissionLoading(
        missionId: event.missionId,
        type: SocialMissionType.completeMission,
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
        SocialMissionError(
          missionId: event.missionId,
          type: SocialMissionType.completeMission,
          message: err,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        SocialMissionJoined(
          missionId: event.missionId,
          hasJoined: state.hasJoined,
          missions: state.missions,
        ),
      ),
    );
  }
}
