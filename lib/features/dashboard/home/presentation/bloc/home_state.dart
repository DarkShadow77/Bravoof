part of 'home_cubit.dart';

enum HomeType {
  getCampaign,
  getSpotlights,
  getSpotlight,
  getExtraCard,
  getQuote,
  getReferrals,
  getLeaderboard,
  getHomeMessage,
}

@immutable
class HomeState extends Equatable {
  final List<CampaignResponseModel> campaign;
  final List<DynamicCarouselModel> extraCard;
  final SpotlightModel spotlight;
  final List<SpotlightModel> spotlights;
  final QuoteModel quote;
  final List<UserProfile> referrals;
  final LeaderboardResponseModel leaderboard;
  final HomeMessageModel homeMessage;
  final bool updateLater;
  final bool hasIncompleteMissions;

  HomeState({
    required this.campaign,
    required this.extraCard,
    required this.spotlight,
    required this.spotlights,
    required this.quote,
    required this.referrals,
    required this.leaderboard,
    required this.homeMessage,
    required this.updateLater,
    required this.hasIncompleteMissions,
  });

  HomeState copyWith({
    List<CampaignResponseModel>? campaign,
    List<DynamicCarouselModel>? extraCard,
    SpotlightModel? spotlight,
    List<SpotlightModel>? spotlights,
    QuoteModel? quote,
    List<UserProfile>? referrals,
    LeaderboardResponseModel? leaderboard,
    HomeMessageModel? homeMessage,
    bool? updateLater,
    bool? hasIncompleteMissions,
  }) {
    return HomeState(
      campaign: campaign ?? this.campaign,
      extraCard: extraCard ?? this.extraCard,
      spotlight: spotlight ?? this.spotlight,
      spotlights: spotlights ?? this.spotlights,
      quote: quote ?? this.quote,
      referrals: referrals ?? this.referrals,
      leaderboard: leaderboard ?? this.leaderboard,
      homeMessage: homeMessage ?? this.homeMessage,
      updateLater: updateLater ?? this.updateLater,
      hasIncompleteMissions:
          hasIncompleteMissions ?? this.hasIncompleteMissions,
    );
  }

  @override
  List<Object?> get props => [
    campaign,
    extraCard,
    spotlight,
    spotlights,
    quote,
    referrals,
    leaderboard,
    homeMessage,
    updateLater,
    hasIncompleteMissions,
  ];
}

final class HomeInitialState extends HomeState {
  HomeInitialState({
    required super.campaign,
    required super.extraCard,
    required super.spotlight,
    required super.spotlights,
    required super.quote,
    required super.referrals,
    required super.leaderboard,
    required super.homeMessage,
    required super.updateLater,
    required super.hasIncompleteMissions,
  });

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {
  final HomeType type;
  HomeLoadingState({
    required this.type,
    required super.campaign,
    required super.extraCard,
    required super.spotlight,
    required super.spotlights,
    required super.quote,
    required super.referrals,
    required super.leaderboard,
    required super.homeMessage,
    required super.updateLater,
    required super.hasIncompleteMissions,
  });

  @override
  List<Object> get props => [type];
}

final class HomeSuccessState extends HomeState {
  final HomeType type;
  final String message;
  HomeSuccessState({
    required this.type,
    required this.message,
    required super.campaign,
    required super.extraCard,
    required super.spotlight,
    required super.spotlights,
    required super.quote,
    required super.referrals,
    required super.leaderboard,
    required super.homeMessage,
    required super.updateLater,
    required super.hasIncompleteMissions,
  });

  @override
  List<Object> get props => [type, message];
}

final class HomeFailureState extends HomeState {
  final HomeType type;
  final String message;
  HomeFailureState({
    required this.type,
    required this.message,
    required super.campaign,
    required super.extraCard,
    required super.spotlight,
    required super.spotlights,
    required super.quote,
    required super.referrals,
    required super.leaderboard,
    required super.homeMessage,
    required super.updateLater,
    required super.hasIncompleteMissions,
  });

  @override
  List<Object> get props => [type, message];
}
