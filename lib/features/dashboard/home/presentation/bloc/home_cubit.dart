import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:Bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:Bravoo/features/dashboard/home/data/repository/home_repository.dart';
import 'package:Bravoo/features/dashboard/home/data/repository/home_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../onbaording/data/model/user_profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository = HomeRepositoryImpl();
  final supabase = Supabase.instance.client;
  HomeCubit()
    : super(
        HomeInitialState(
          campaign: [],
          spotlight: SpotlightModel.empty(),
          referrals: [],
        ),
      );

  void fetchCampaigns() async {
    if (state.campaign.isEmpty)
      emit(
        HomeLoadingState(
          type: HomeType.getCampaign,
          campaign: state.campaign,
          spotlight: state.spotlight,
          referrals: state.referrals,
        ),
      );

    final either = await homeRepository.fetchCampaigns();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getCampaign,
          message: failure.toString(),
          campaign: state.campaign,
          spotlight: state.spotlight,
          referrals: state.referrals,
        ),
      ),
      (campaign) {
        emit(state.copyWith(campaign: campaign));
        emit(
          HomeSuccessState(
            type: HomeType.getCampaign,
            message: "Campaign Got Successfully",
            campaign: campaign,
            spotlight: state.spotlight,
            referrals: state.referrals,
          ),
        );
      },
    );
  }

  void fetchSpotlight() async {
    if (state.spotlight.name.isEmpty)
      emit(
        HomeLoadingState(
          type: HomeType.getSpotlight,
          campaign: state.campaign,
          spotlight: state.spotlight,
          referrals: state.referrals,
        ),
      );

    final either = await homeRepository.fetchSpotlight();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getSpotlight,
          message: failure.toString(),
          campaign: state.campaign,
          spotlight: state.spotlight,
          referrals: state.referrals,
        ),
      ),
      (spotlight) {
        emit(state.copyWith(spotlight: spotlight));
        emit(
          HomeSuccessState(
            type: HomeType.getSpotlight,
            message: "Spotlight Got Successfully",
            campaign: state.campaign,
            spotlight: spotlight,
            referrals: state.referrals,
          ),
        );
      },
    );
  }

  void getUserReferrals() async {
    final res = await homeRepository.getAllUserReferrals(
      userId: supabase.auth.currentUser!.id,
    );

    res.fold((err) => print(err), (list) {
      print('Referrals: ${list.map((e) => e.toJson())}');
      emit(state.copyWith(referrals: list));
    });
  }
}
