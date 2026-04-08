import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../data/model/response/squad_mission_model.dart';
import '../../data/repository/squad_repository.dart';

part 'squad_individual_event.dart';
part 'squad_individual_state.dart';

class SquadIndividualBloc
    extends Bloc<SquadIndividualEvent, SquadIndividualState> {
  final SquadRepository repo;
  final String squadId;

  final supabase = Supabase.instance.client;

  SquadIndividualBloc({required this.repo, required this.squadId})
    : super(SquadIndividualInitialState(missions: [])) {
    on<FetchSquadMissionsEvent>(_fetchMissions);
    add(FetchSquadMissionsEvent());
    // on<CompleteSquadMissionEvent>(_completeMission);
  }

  Future<void> _fetchMissions(
    FetchSquadMissionsEvent event,
    Emitter<SquadIndividualState> emit,
  ) async {
    emit(
      SquadIndividualLoadingState(
        type: SquadIndividualType.fetch,
        missions: state.missions,
      ),
    );

    final res = await repo.fetchSquadMissions(squadId: squadId);

    res.fold(
      (err) => emit(
        SquadIndividualErrorState(
          type: SquadIndividualType.fetch,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) {
        emit(state.copyWith(missions: missions));
        emit(
          SquadIndividualErrorState(
            type: SquadIndividualType.fetch,
            message: "Fetched Squad Missions Successfully",
            missions: missions,
          ),
        );
      },
    );
  }

  /*Future<void> _completeMission(
    CompleteSquadMissionEvent event,
    Emitter<SquadIndividualState> emit,
  ) async {
    emit(
      SquadIndividualLoadingState(
        type: SquadIndividualType.complete,
        missionId: event.missionId,
        missions: state.missions,
      ),
    );

    final res = await repo.completeMission(
      missionId: event.missionId,
      userId: supabase.auth.currentUser!.id,
      image: event.image,
      text: event.text,
    );

    res.fold(
      (err) => emit(
        SquadIndividualErrorState(
          type: SquadIndividualType.complete,
          missionId: event.missionId,
          message: err,
          missions: state.missions,
        ),
      ),
      (message) {
        // Reflect PENDING status locally so the UI updates without a refetch
        final updated = state.missions.map((m) {
          if (m.id != event.missionId) return m;
          return SquadMission(
            id: m.id,
            squadId: m.squadId,
            title: m.title,
            subtitle: m.subtitle,
            instructionTitle: m.instructionTitle,
            instructions: m.instructions,
            points: m.points,
            submissionType: m.submissionType,
            maxUsers: m.maxUsers,
            usersJoined: m.usersJoined,
            active: m.active,
            createdAt: m.createdAt,
            userStatus: MissionStatus.pending,
          );
        }).toList();

        emit(
          SquadIndividualSuccessState(
            type: SquadIndividualType.complete,
            missionId: event.missionId,
            missions: updated,
            message: message,
          ),
        );
      },
    );
  }*/
}
