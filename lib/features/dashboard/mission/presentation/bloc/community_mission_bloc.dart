import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/community_mission_model.dart';
import '../../data/repository/community_mission_repository.dart';

part 'community_mission_event.dart';
part 'community_mission_state.dart';

class CommunityMissionBloc
    extends Bloc<CommunityMissionEvent, CommunityMissionState> {
  final CommunityMissionRepository repo;
  final supabase = Supabase.instance.client;

  CommunityMissionBloc({required this.repo})
    : super(CommunityMissionInitial(mission: null)) {
    on<LoadCommunityMission>(_loadMission);
    on<JoinCommunityMission>(_joinMission);
  }

  Future<void> _loadMission(LoadCommunityMission event, Emitter emit) async {
    emit(
      CommunityMissionLoading(
        type: CommunityMissionType.fetchMission,
        mission: state.mission,
      ),
    );

    final missionRes = await repo.fetchCommunityMission();

    missionRes.fold(
      (err) => emit(
        CommunityMissionError(
          type: CommunityMissionType.fetchMission,
          message: err,
          mission: state.mission,
        ),
      ),
      (mission) => emit(state.copWith(mission: mission)),
    );
  }

  Future<void> _joinMission(JoinCommunityMission event, Emitter emit) async {
    emit(
      CommunityMissionLoading(
        type: CommunityMissionType.joinMission,
        mission: state.mission,
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
        CommunityMissionError(
          type: CommunityMissionType.joinMission,
          message: err,
          // hasJoined: state.hasJoined,
          mission: state.mission,
        ),
      ),
      (_) => emit(CommunityMissionJoined(mission: state.mission)),
    );
  }
}
