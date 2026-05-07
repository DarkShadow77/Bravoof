import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/community_mission_model.dart';
import '../../data/model/mission_status_enum.dart';
import '../../data/repository/community_mission_repository.dart';

part 'community_mission_event.dart';
part 'community_mission_state.dart';

class CommunityMissionBloc
    extends Bloc<CommunityMissionEvent, CommunityMissionState> {
  final CommunityMissionRepository repo;
  final supabase = Supabase.instance.client;

  CommunityMissionBloc({required this.repo})
    : super(
        CommunityMissionInitial(
          hasJoined: MissionStatus.notJoined,
          mission: null,
        ),
      ) {
    on<LoadCommunityMission>(_loadMission);
    on<JoinCommunityMission>(_joinMission);
    on<CheckJoinStatus>(_checkJoinStatus);
  }

  Future<void> _loadMission(LoadCommunityMission event, Emitter emit) async {
    emit(
      CommunityMissionLoading(
        type: CommunityMissionType.fetchMission,
        hasJoined: state.hasJoined,
        mission: state.mission,
      ),
    );

    final missionRes = await repo.fetchCommunityMission();

    missionRes.fold(
      (err) => emit(
        CommunityMissionError(
          type: CommunityMissionType.fetchMission,
          message: err,
          hasJoined: state.hasJoined,
          mission: state.mission,
        ),
      ),
      (mission) {
        emit(state.copWith(mission: mission));
        add(CheckJoinStatus());
      },
    );
  }

  Future<void> _checkJoinStatus(CheckJoinStatus event, Emitter emit) async {
    emit(
      CommunityMissionLoading(
        type: CommunityMissionType.checkJoinStatus,
        hasJoined: state.hasJoined,
        mission: state.mission,
      ),
    );

    if (state.mission != null) {
      final joined = await repo.hasJoined(
        missionId: state.mission!.id,
        userId: supabase.auth.currentUser!.id,
      );

      joined.fold(
        (err) => emit(state.copWith(hasJoined: MissionStatus.notJoined)),
        (data) => emit(state.copWith(hasJoined: data)),
      );
    } else {
      emit(state.copWith(hasJoined: MissionStatus.notJoined));
    }
  }

  Future<void> _joinMission(JoinCommunityMission event, Emitter emit) async {
    emit(
      CommunityMissionLoading(
        type: CommunityMissionType.joinMission,
        hasJoined: state.hasJoined,
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
          hasJoined: state.hasJoined,
          mission: state.mission,
        ),
      ),
      (_) => emit(
        CommunityMissionJoined(
          hasJoined: state.hasJoined,
          mission: state.mission,
        ),
      ),
    );
  }
}
