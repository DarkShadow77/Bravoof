import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/featured_mission_model.dart';
import '../../data/repository/featured_mission_repository.dart';

part 'featured_mission_event.dart';
part 'featured_mission_state.dart';

class FeaturedMissionBloc
    extends Bloc<FeaturedMissionEvent, FeaturedMissionState> {
  final FeaturedMissionRepository repo;

  FeaturedMissionBloc({required this.repo})
    : super(FeaturedMissionInitial(missions: [])) {
    on<LoadFeaturedMission>(_loadMission);
    on<CompleteFeaturedMission>(_completeMission);
  }

  Future<void> _loadMission(LoadFeaturedMission event, Emitter emit) async {
    emit(
      FeaturedMissionLoading(
        type: FeaturedMissionType.fetchMission,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchFeaturedMission();

    missionRes.fold(
      (err) => emit(
        FeaturedMissionError(
          type: FeaturedMissionType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) => emit(state.copWith(missions: missions)),
    );
  }

  Future<void> _completeMission(
    CompleteFeaturedMission event,
    Emitter emit,
  ) async {
    emit(
      FeaturedMissionLoading(
        missionId: event.missionId,
        type: FeaturedMissionType.completeMission,
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
        FeaturedMissionError(
          missionId: event.missionId,
          type: FeaturedMissionType.completeMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        FeaturedMissionJoined(
          missionId: event.missionId,
          missions: state.missions,
        ),
      ),
    );
  }
}
