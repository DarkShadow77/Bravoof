import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../data/model/response/brand_mission_model.dart';
import '../../data/repository/brand_repository.dart';

part 'brand_individual_event.dart';
part 'brand_individual_state.dart';

class BrandIndividualBloc
    extends Bloc<BrandIndividualEvent, BrandIndividualState> {
  final BrandRepository repo;
  final String brandId;

  final supabase = Supabase.instance.client;

  BrandIndividualBloc({required this.repo, required this.brandId})
    : super(BrandMissionsInitialState(missions: [])) {
    on<FetchBrandMissionsEvent>(_fetchMissions);
    add(FetchBrandMissionsEvent());
    // on<CompleteBrandMissionEvent>(_completeMission);
  }

  Future<void> _fetchMissions(
    FetchBrandMissionsEvent event,
    Emitter<BrandIndividualState> emit,
  ) async {
    emit(
      BrandIndividualLoadingState(
        type: BrandIndividualType.fetch,
        missions: state.missions,
      ),
    );

    final res = await repo.fetchBrandMissions(brandId: brandId);

    res.fold(
      (err) => emit(
        BrandIndividualErrorState(
          type: BrandIndividualType.fetch,
          message: err,
          missions: state.missions,
        ),
      ),
      (missions) {
        emit(state.copyWith(missions: missions));
        emit(
          BrandIndividualSuccessState(
            type: BrandIndividualType.fetch,
            message: "Fetched Brand Missions Successfully",
            missions: missions,
          ),
        );
      },
    );
  }

  /*Future<void> _completeMission(
    CompleteBrandMissionEvent event,
    Emitter<BrandIndividualState> emit,
  ) async {
    emit(
      BrandIndividualLoadingState(
        type: BrandIndividualType.complete,
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
        BrandIndividualErrorState(
          type: BrandIndividualType.complete,
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
            type: BrandIndividualType.complete,
            missionId: event.missionId,
            missions: updated,
            message: message,
          ),
        );
      },
    );
  }*/
}
