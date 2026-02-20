import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:bravoo/features/dashboard/home/data/model/leaderboard_response_model.dart';
import 'package:bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:bravoo/features/dashboard/home/data/repository/home_repository.dart';
import 'package:bravoo/features/dashboard/home/data/repository/home_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../profile/data/model/user_profile.dart';
import '../../data/model/dynamic_carousel_model.dart';
import '../../data/model/quote_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository = HomeRepositoryImpl();
  final supabase = Supabase.instance.client;
  HomeCubit()
    : super(
        HomeInitialState(
          campaign: [],
          extraCard: [],
          spotlight: SpotlightModel.empty(),
          referrals: [],
          quote: QuoteModel.empty(),
          leaderboard: LeaderboardResponseModel.empty(),
        ),
      );

  void fetchCampaigns() async {
    if (state.campaign.isEmpty)
      emit(
        HomeLoadingState(
          type: HomeType.getCampaign,
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      );

    final either = await homeRepository.fetchCampaigns();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getCampaign,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      ),
      (campaign) {
        emit(state.copyWith(campaign: campaign));
        emit(
          HomeSuccessState(
            type: HomeType.getCampaign,
            message: "Campaign Got Successfully",
            campaign: campaign,
            extraCard: state.extraCard,
            spotlight: state.spotlight,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
          ),
        );
      },
    );
  }

  void fetchExtraHomeCard() async {
    emit(
      HomeLoadingState(
        type: HomeType.getExtraCard,
        campaign: state.campaign,
        extraCard: state.extraCard,
        spotlight: state.spotlight,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
      ),
    );

    final either = await homeRepository.fetchExtraHomeCard();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getExtraCard,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      ),
      (extraCard) {
        emit(state.copyWith(extraCard: extraCard));
        emit(
          HomeSuccessState(
            type: HomeType.getExtraCard,
            message: "Home Extra Card Got Successfully",
            campaign: state.campaign,
            extraCard: extraCard,
            spotlight: state.spotlight,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
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
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      );

    final either = await homeRepository.fetchSpotlight();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getSpotlight,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      ),
      (spotlight) {
        emit(state.copyWith(spotlight: spotlight));
        emit(
          HomeSuccessState(
            type: HomeType.getSpotlight,
            message: "Spotlight Got Successfully",
            campaign: state.campaign,
            extraCard: state.extraCard,
            spotlight: spotlight,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
          ),
        );
      },
    );
  }

  void fetchQuote() async {
    emit(
      HomeLoadingState(
        type: HomeType.getQuote,
        campaign: state.campaign,
        extraCard: state.extraCard,
        spotlight: state.spotlight,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
      ),
    );

    final either = await homeRepository.fetchQuote();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getQuote,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      ),
      (quote) {
        emit(state.copyWith(quote: quote));
        emit(
          HomeSuccessState(
            type: HomeType.getQuote,
            message: "Quotes Got Successfully",
            campaign: state.campaign,
            extraCard: state.extraCard,
            quote: quote,
            spotlight: state.spotlight,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
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

  void fetchLeaderboard() async {
    emit(
      HomeLoadingState(
        type: HomeType.getLeaderboard,
        campaign: state.campaign,
        extraCard: state.extraCard,
        spotlight: state.spotlight,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
      ),
    );

    final res = await homeRepository.fetchLeaderboard(
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getLeaderboard,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
        ),
      ),
      (leaderboard) {
        emit(state.copyWith(leaderboard: leaderboard));
        emit(
          HomeSuccessState(
            type: HomeType.getLeaderboard,
            message: "Leaderboard Got Successfully",
            campaign: state.campaign,
            extraCard: state.extraCard,
            quote: state.quote,
            spotlight: state.spotlight,
            referrals: state.referrals,
            leaderboard: leaderboard,
          ),
        );
      },
    );
  }
}
