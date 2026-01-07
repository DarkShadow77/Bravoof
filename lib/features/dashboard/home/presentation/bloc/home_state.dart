part of 'home_cubit.dart';

enum HomeType { getCampaign, getSpotlight, getReferrals }

@immutable
class HomeState extends Equatable {
  final List<CampaignModel> campaign;
  final SpotlightModel spotlight;
  final List<UserProfile> referrals;

  HomeState({
    required this.campaign,
    required this.spotlight,
    required this.referrals,
  });

  HomeState copyWith({
    List<CampaignModel>? campaign,
    SpotlightModel? spotlight,
    List<UserProfile>? referrals,
  }) {
    return HomeState(
      campaign: campaign ?? this.campaign,
      spotlight: spotlight ?? this.spotlight,
      referrals: referrals ?? this.referrals,
    );
  }

  @override
  List<Object?> get props => [campaign, spotlight, referrals];
}

final class HomeInitialState extends HomeState {
  HomeInitialState({
    required super.campaign,
    required super.spotlight,
    required super.referrals,
  });

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {
  final HomeType type;
  HomeLoadingState({
    required this.type,
    required super.campaign,
    required super.spotlight,
    required super.referrals,
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
    required super.spotlight,
    required super.referrals,
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
    required super.spotlight,
    required super.referrals,
  });

  @override
  List<Object> get props => [type, message];
}
