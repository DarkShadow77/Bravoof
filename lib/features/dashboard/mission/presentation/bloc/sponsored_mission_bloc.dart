import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/mission_status_enum.dart';
import '../../data/model/sponsored_mission_model.dart';
import '../../data/repository/sponsored_mission_repository.dart';

part 'sponsored_mission_event.dart';
part 'sponsored_mission_state.dart';

class SponsoredMissionBloc
    extends Bloc<SponsoredMissionEvent, SponsoredMissionState> {
  final SponsoredMissionRepository repo;

  SponsoredMissionBloc({required this.repo})
    : super(SponsoredMissionInitial(missions: [])) {
    on<LoadSponsoredMission>(_loadMission);
    on<CompleteSponsoredMission>(_completeMission);
  }

  Future<void> _loadMission(LoadSponsoredMission event, Emitter emit) async {
    emit(
      SponsoredMissionLoading(
        type: SponsoredMissionType.fetchMission,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchSponsoredMission();

    missionRes.fold(
      (err) => emit(
        SponsoredMissionError(
          type: SponsoredMissionType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) =>
        emit(state.copWith(missions: missions)),
    );
  }

  Future<void> _completeMission(
    CompleteSponsoredMission event,
    Emitter emit,
  ) async {
    emit(
      SponsoredMissionLoading(
        missionId: event.missionId,
        type: SponsoredMissionType.completeMission,
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
          missions: state.missions,
        ),
      ),
      (_) => emit(
        SponsoredMissionJoined(
          missionId: event.missionId,
          missions: state.missions,
        ),
      ),
    );
  }
}
