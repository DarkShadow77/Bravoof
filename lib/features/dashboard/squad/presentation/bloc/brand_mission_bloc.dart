import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../../mission/data/model/mission_status_enum.dart';
import '../../data/model/response/brand_mission_model.dart';
import '../../data/repository/brand_repository.dart';

part 'brand_mission_event.dart';
part 'brand_mission_state.dart';

class BrandMissionsBloc extends Bloc<BrandMissionsEvent, BrandMissionsState> {
  final BrandRepository repo;
  final String brandId;

  final supabase = Supabase.instance.client;

  BrandMissionsBloc({required this.repo, required this.brandId})
    : super(BrandMissionsInitialState(missions: [])) {
    on<FetchBrandMissionsEvent>(_fetchMissions);
    on<CompleteBrandMissionEvent>(_completeMission);
  }

  Future<void> _fetchMissions(
    FetchBrandMissionsEvent event,
    Emitter<BrandMissionsState> emit,
  ) async {
    emit(
      BrandMissionsLoadingState(
        type: BrandMissionsType.fetch,
        missions: state.missions,
      ),
    );

    final res = await repo.fetchBrandMissions(brandId: brandId);

    res.fold(
      (err) => emit(
        BrandMissionsErrorState(
          type: BrandMissionsType.fetch,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) => emit(BrandMissionsLoadedState(missions: missions)),
    );
  }

  Future<void> _completeMission(
    CompleteBrandMissionEvent event,
    Emitter<BrandMissionsState> emit,
  ) async {
    emit(
      BrandMissionsLoadingState(
        type: BrandMissionsType.complete,
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
        BrandMissionsErrorState(
          type: BrandMissionsType.complete,
          missionId: event.missionId,
          message: err,
          missions: state.missions,
        ),
      ),
      (message) {
        // Reflect PENDING status locally so the UI updates without a refetch
        final updated = state.missions.map((m) {
          if (m.id != event.missionId) return m;
          return BrandMission(
            id: m.id,
            brandId: m.brandId,
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
          BrandMissionsSuccessState(
            type: BrandMissionsType.complete,
            missionId: event.missionId,
            missions: updated,
            message: message,
          ),
        );
      },
    );
  }
}
