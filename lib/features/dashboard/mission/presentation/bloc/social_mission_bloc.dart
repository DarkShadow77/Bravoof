import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/mission_status_enum.dart';
import '../../data/model/social_mission_model.dart';
import '../../data/repository/social_mission_repository.dart';

part 'social_mission_event.dart';
part 'social_mission_state.dart';

class SocialMissionBloc extends Bloc<SocialMissionEvent, SocialMissionState> {
  final SocialMissionRepository repo;

  SocialMissionBloc({required this.repo})
    : super(SocialMissionInitial(missions: [])) {
    on<LoadSocialMission>(_loadMission);
    on<CompleteSocialMission>(_completeMission);
  }

  Future<void> _loadMission(LoadSocialMission event, Emitter emit) async {
    emit(
      SocialMissionLoading(
        type: SocialMissionType.fetchMission,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchSocialMission();

    missionRes.fold(
      (err) => emit(
        SocialMissionError(
          type: SocialMissionType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) => emit(state.copWith(missions: missions)),
    );
  }

  Future<void> _completeMission(
    CompleteSocialMission event,
    Emitter emit,
  ) async {
    emit(
      SocialMissionLoading(
        missionId: event.missionId,
        type: SocialMissionType.completeMission,
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
        SocialMissionError(
          missionId: event.missionId,
          type: SocialMissionType.completeMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        SocialMissionJoined(
          missionId: event.missionId,
          missions: state.missions,
        ),
      ),
    );
  }
}
