part of 'home_cubit.dart';

enum HomeType {
  getCampaign,
  getSpotlight,
  getExtraCard,
  getQuote,
  getReferrals,
  getLeaderboard,
}

@immutable
class HomeState extends Equatable {
  final List<CampaignResponseModel> campaign;
  final List<DynamicCarouselModel> extraCard;
  final SpotlightModel spotlight;
  final QuoteModel quote;
  final List<UserProfile> referrals;
  final LeaderboardResponseModel leaderboard;

  HomeState({
    required this.campaign,
    required this.extraCard,
    required this.spotlight,
    required this.quote,
    required this.referrals,
    required this.leaderboard,
  });

  HomeState copyWith({
    List<CampaignResponseModel>? campaign,
    List<DynamicCarouselModel>? extraCard,
    SpotlightModel? spotlight,
    QuoteModel? quote,
    List<UserProfile>? referrals,
    LeaderboardResponseModel? leaderboard,
  }) {
    return HomeState(
      campaign: campaign ?? this.campaign,
      extraCard: extraCard ?? this.extraCard,
      spotlight: spotlight ?? this.spotlight,
      quote: quote ?? this.quote,
      referrals: referrals ?? this.referrals,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }

  @override
  List<Object?> get props => [
    campaign,
    extraCard,
    spotlight,
    quote,
    referrals,
    leaderboard,
  ];
}

final class HomeInitialState extends HomeState {
  HomeInitialState({
    required super.campaign,
    required super.extraCard,
    required super.spotlight,
    required super.quote,
    required super.referrals,
    required super.leaderboard,
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
    required super.quote,
    required super.referrals,
    required super.leaderboard,
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
    required super.quote,
    required super.referrals,
    required super.leaderboard,
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
    required super.quote,
    required super.referrals,
    required super.leaderboard,
  });

  @override
  List<Object> get props => [type, message];
}
