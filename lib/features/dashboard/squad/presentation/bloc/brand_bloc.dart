import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/response/brand_model.dart';
import '../../data/repository/brand_repository.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository repo;

  BrandBloc({required this.repo}) : super(BrandInitialState(brands: [])) {
    on<FetchBrandsEvent>(_fetchBrands);
    on<FollowUnfollowBrandEvent>(_followUnfollowBrand);
  }

  Future<void> _fetchBrands(FetchBrandsEvent event, Emitter emit) async {
    emit(BrandLoadingState(type: BrandType.fetchBrands, brands: state.brands));

    final res = await repo.fetchBrands();

    log("Brand Response ${res.toString()}");

    res.fold(
      (err) => emit(
        BrandErrorState(
          type: BrandType.fetchBrands,
          message: err,
          brands: state.brands,
        ),
      ),
      (brands) => emit(state.copWith(brands: brands)),
    );
  }

  Future<void> _followUnfollowBrand(
    FollowUnfollowBrandEvent event,
    Emitter emit,
  ) async {
    emit(
      BrandLoadingState(
        brandId: event.brandId,
        type: BrandType.followUnfollowBrand,
        brands: state.brands,
      ),
    );

    final res = await repo.followUnfollowBrand(brandId: event.brandId);

    res.fold(
      (err) => emit(
        BrandErrorState(
          brandId: event.brandId,
          type: BrandType.followUnfollowBrand,
          message: err,
          brands: state.brands,
        ),
      ),
      (message) {
        // Reflect PENDING status locally so the UI updates without a refetch
        final updated = state.brands.map((m) {
          if (m.id != event.brandId) return m;
          return Brand(
            id: m.id,
            name: m.name,
            about: m.about,
            logo: m.logo,
            logoBgColor: m.logoBgColor,
            gradientColor: m.gradientColor,
            textColor: m.textColor,
            inverseTextColor: m.inverseTextColor,
            missionCount: m.missionCount,
            followerCount: m.followerCount,
            followers: m.followers,
            isFollowing: !m.isFollowing,
            active: m.active,
            createdAt: m.createdAt,
          );
        }).toList();
        emit(
          BrandSuccessState(
            brandId: event.brandId,
            type: BrandType.followUnfollowBrand,
            brands: updated,
            message: message,
          ),
        );
        add(FetchBrandsEvent());
      },
    );
  }
}
