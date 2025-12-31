import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../session/session_manager.dart';
import '../../data/model/skill_up_mission_model.dart';
import '../../data/repository/skill_up_repository.dart';

part 'skill_up_event.dart';
part 'skill_up_state.dart';

class SkillUpBloc extends Bloc<SkillUpEvent, SkillUpState> {
  final SkillUpRepository repo;
  SessionManager session = SessionManager();

  SkillUpBloc({required this.repo}) : super(SkillUpInitial(missions: [])) {
    on<LoadSkillUpMission>(_loadMission);
    on<CompleteSkillUpMission>(_completeMission);
    on<UnlockSkillUpMission>(_unlockSkillUp);
  }

  Future<void> _loadMission(LoadSkillUpMission event, Emitter emit) async {
    log("Skill Up Loading");
    if (state.missions.isEmpty)
      emit(
        SkillUpLoading(
          type: SkillUpType.fetchMission,
          missions: state.missions,
        ),
      );

    final missionRes = await repo.fetchSkillUpMission(
      userId: session.userIdVal,
    );

    log("Skill Up Missions $missionRes");
    missionRes.fold(
      (err) => emit(
        SkillUpError(
          type: SkillUpType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) {
        emit(state.copWith(missions: missions));
      },
    );
  }

  Future<void> _completeMission(
    CompleteSkillUpMission event,
    Emitter emit,
  ) async {
    emit(
      SkillUpLoading(
        missionId: event.missionId,
        type: SkillUpType.completeMission,
        missions: state.missions,
      ),
    );

    final res = await repo.completeSkillUpStep(
      skillUpMissionId: event.missionId,
      stepId: event.stepId,
      userId: session.userIdVal,
      submission: event.text,
      evidenceImage: event.imageUrl,
    );

    res.fold(
      (err) => emit(
        SkillUpError(
          missionId: event.missionId,
          type: SkillUpType.completeMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        SkillUpCompleted(
          missionId: event.missionId,
          stepId: event.stepId,
          missions: state.missions,
        ),
      ),
    );
  }

  Future<void> _unlockSkillUp(UnlockSkillUpMission event, Emitter emit) async {
    emit(
      SkillUpLoading(
        missionId: event.stepId,
        type: SkillUpType.unlockSkillUp,
        missions: state.missions,
      ),
    );

    final res = await repo.unlockSkillUpStep(
      userId: session.userIdVal,
      stepId: event.stepId,
      source: event.source,
    );

    res.fold(
      (err) => emit(
        SkillUpError(
          missionId: event.stepId,
          type: SkillUpType.unlockSkillUp,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) =>
          emit(SkillUpUnlocked(stepId: event.stepId, missions: state.missions)),
    );
  }
}
