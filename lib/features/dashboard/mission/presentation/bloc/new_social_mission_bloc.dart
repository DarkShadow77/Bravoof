import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/new_social_mission_model.dart';
import '../../data/repository/new_social_mission_repository.dart';

part 'new_social_mission_event.dart';
part 'new_social_mission_state.dart';

class NewSocialMissionBloc
    extends Bloc<NewSocialMissionEvent, NewSocialMissionState> {
  final NewSocialMissionRepository repo;

  NewSocialMissionBloc({required this.repo})
    : super(NewSocialMissionInitial(missions: [])) {
    on<LoadNewSocialMission>(_loadMission);
    on<CompleteNewSocialMission>(_completeMission);
  }

  Future<void> _loadMission(LoadNewSocialMission event, Emitter emit) async {
    emit(
      NewSocialMissionLoading(
        type: NewSocialMissionType.fetchMission,
        missions: state.missions,
      ),
    );

    final missionRes = await repo.fetchNewSocialMission();

    missionRes.fold(
      (err) => emit(
        NewSocialMissionError(
          type: NewSocialMissionType.fetchMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) => emit(state.copWith(missions: missions)),
    );
  }

  Future<void> _completeMission(
    CompleteNewSocialMission event,
    Emitter emit,
  ) async {
    emit(
      NewSocialMissionLoading(
        missionId: event.missionId,
        type: NewSocialMissionType.completeMission,
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
        NewSocialMissionError(
          missionId: event.missionId,
          type: NewSocialMissionType.completeMission,
          message: err,
          missions: state.missions,
        ),
      ),
      (_) => emit(
        NewSocialMissionJoined(
          missionId: event.missionId,
          missions: state.missions,
        ),
      ),
    );
  }
}
