import 'package:bloc/bloc.dart';
import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:bravoo/features/dashboard/home/data/model/leaderboard_response_model.dart';
import 'package:bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:bravoo/features/dashboard/home/data/repository/home_repository.dart';
import 'package:bravoo/features/dashboard/home/data/repository/home_repository_impl.dart';
import 'package:bravoo/features/dashboard/profile/data/model/users_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mission/data/model/mission_status_enum.dart';
import '../../../mission/presentation/bloc/community_mission_bloc.dart';
import '../../../mission/presentation/bloc/featured_mission_bloc.dart';
import '../../../mission/presentation/bloc/new_social_mission_bloc.dart';
import '../../../mission/presentation/bloc/social_mission_bloc.dart';
import '../../../mission/presentation/bloc/sponsored_mission_bloc.dart';
import '../../data/model/dynamic_carousel_model.dart';
import '../../data/model/home_message_model.dart';
import '../../data/model/quote_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository = HomeRepositoryImpl();
  final supabase = Supabase.instance.client;

  CommunityMissionBloc? communityMissionBloc;
  FeaturedMissionBloc? featuredMissionBloc;
  NewSocialMissionBloc? newSocialMissionBloc;
  SocialMissionBloc? socialMissionBloc;
  SponsoredMissionBloc? sponsoredMissionBloc;
  HomeCubit({
    this.communityMissionBloc,
    this.featuredMissionBloc,
    this.newSocialMissionBloc,
    this.socialMissionBloc,
    this.sponsoredMissionBloc,
  }) : super(
         HomeInitialState(
           campaign: [],
           extraCard: [],
           spotlight: SpotlightModel.empty(),
           spotlights: [],
           referrals: [],
           quote: QuoteModel.empty(),
           leaderboard: LeaderboardResponseModel.empty(),
           homeMessage: HomeMessageModel.empty(),
           updateLater: false,
           hasIncompleteMissions: false,
         ),
       );

  void updateLater(bool updateLater) async {
    emit(state.copyWith(updateLater: updateLater));
  }

  void checkComplete() async {
    emit(state.copyWith(hasIncompleteMissions: false));
  }

  void checkIncompleteMissions() {
    bool hasIncomplete = false;

    // Check community missions
    if (communityMissionBloc != null) {
      final communityState = communityMissionBloc!.state;
      final status = communityState.hasJoined;
      if (status == MissionStatus.notJoined ||
          status == MissionStatus.rejected) {
        hasIncomplete = true;
      }
    }

    // Check featured missions
    if (featuredMissionBloc != null && !hasIncomplete) {
      final featuredState = featuredMissionBloc!.state;
      if (featuredState.hasJoined.any(
        (status) =>
            status == MissionStatus.notJoined ||
            status == MissionStatus.rejected,
      )) {
        hasIncomplete = true;
      }
    }

    // Check new social missions
    if (newSocialMissionBloc != null && !hasIncomplete) {
      final newSocialState = newSocialMissionBloc!.state;
      if (newSocialState.hasJoined.any(
        (status) =>
            status == MissionStatus.notJoined ||
            status == MissionStatus.rejected,
      )) {
        hasIncomplete = true;
      }
    }

    // Check social missions
    if (socialMissionBloc != null && !hasIncomplete) {
      final socialState = socialMissionBloc!.state;
      if (socialState.hasJoined.any(
        (status) =>
            status == MissionStatus.notJoined ||
            status == MissionStatus.rejected,
      )) {
        hasIncomplete = true;
      }
    }

    // Check sponsored missions
    if (sponsoredMissionBloc != null && !hasIncomplete) {
      final sponsoredState = sponsoredMissionBloc!.state;
      if (sponsoredState.hasJoined.any(
        (status) =>
            status == MissionStatus.notJoined ||
            status == MissionStatus.rejected,
      )) {
        hasIncomplete = true;
      }
    }

    // Update state
    emit(state.copyWith(hasIncompleteMissions: hasIncomplete));
  }

  void fetchCampaigns() async {
    if (state.campaign.isEmpty)
      emit(
        HomeLoadingState(
          type: HomeType.getCampaign,
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
            spotlights: state.spotlights,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: state.homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
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
        spotlights: state.spotlights,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
        homeMessage: state.homeMessage,
        updateLater: state.updateLater,
        hasIncompleteMissions: state.hasIncompleteMissions,
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
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
            spotlights: state.spotlights,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: state.homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
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
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
            spotlights: state.spotlights,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: state.homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
          ),
        );
      },
    );
  }

  void fetchSpotlights() async {
    if (state.spotlights.isEmpty)
      emit(
        HomeLoadingState(
          type: HomeType.getSpotlights,
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
        ),
      );

    final either = await homeRepository.fetchSpotlights();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getSpotlights,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
        ),
      ),
      (spotlights) {
        emit(state.copyWith(spotlights: spotlights));
        emit(
          HomeSuccessState(
            type: HomeType.getSpotlights,
            message: "Spotlight Got Successfully",
            campaign: state.campaign,
            extraCard: state.extraCard,
            spotlights: spotlights,
            spotlight: state.spotlight,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: state.homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
          ),
        );
      },
    );
  }

  void fetchHomeMessage() async {
    emit(
      HomeLoadingState(
        type: HomeType.getSpotlights,
        campaign: state.campaign,
        extraCard: state.extraCard,
        spotlight: state.spotlight,
        spotlights: state.spotlights,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
        homeMessage: state.homeMessage,
        updateLater: state.updateLater,
        hasIncompleteMissions: state.hasIncompleteMissions,
      ),
    );

    final either = await homeRepository.fetchHomeMessage();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getSpotlights,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
        ),
      ),
      (homeMessage) {
        emit(state.copyWith(homeMessage: homeMessage));
        emit(
          HomeSuccessState(
            type: HomeType.getSpotlights,
            message: "Spotlight Got Successfully",
            campaign: state.campaign,
            extraCard: state.extraCard,
            spotlights: state.spotlights,
            spotlight: state.spotlight,
            quote: state.quote,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
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
        spotlights: state.spotlights,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
        homeMessage: state.homeMessage,
        updateLater: state.updateLater,
        hasIncompleteMissions: state.hasIncompleteMissions,
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
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
            spotlights: state.spotlights,
            referrals: state.referrals,
            leaderboard: state.leaderboard,
            homeMessage: state.homeMessage,
            updateLater: state.updateLater,
            hasIncompleteMissions: state.hasIncompleteMissions,
          ),
        );
      },
    );
  }

  void getUserReferrals() async {
    final res = await homeRepository.getAllUserReferrals();

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
        spotlights: state.spotlights,
        quote: state.quote,
        referrals: state.referrals,
        leaderboard: state.leaderboard,
        homeMessage: state.homeMessage,
        updateLater: state.updateLater,
        hasIncompleteMissions: state.hasIncompleteMissions,
      ),
    );

    final res = await homeRepository.fetchLeaderboard();

    res.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getLeaderboard,
          message: failure.toString(),
          campaign: state.campaign,
          extraCard: state.extraCard,
          spotlight: state.spotlight,
          spotlights: state.spotlights,
          quote: state.quote,
          referrals: state.referrals,
          leaderboard: state.leaderboard,
          homeMessage: state.homeMessage,
          updateLater: state.updateLater,
          hasIncompleteMissions: state.hasIncompleteMissions,
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
            spotlights: state.spotlights,
            referrals: state.referrals,
            updateLater: state.updateLater,
            homeMessage: state.homeMessage,
            hasIncompleteMissions: state.hasIncompleteMissions,
            leaderboard: leaderboard,
          ),
        );
      },
    );
  }
}
