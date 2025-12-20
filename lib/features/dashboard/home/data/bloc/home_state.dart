part of 'home_cubit.dart';

enum HomeType { getCampaign, getReferrals }

@immutable
class HomeState extends Equatable {
  final CampaignResponse campaignResponse;
  final List<UserProfile> referrals;

  HomeState({required this.campaignResponse, required this.referrals});

  HomeState copyWith({
    CampaignResponse? campaignResponse,
    List<UserProfile>? referrals,
  }) {
    return HomeState(
      campaignResponse: campaignResponse ?? this.campaignResponse,
      referrals: referrals ?? this.referrals,
    );
  }

  @override
  List<Object?> get props => [campaignResponse, referrals];
}

final class HomeInitialState extends HomeState {
  HomeInitialState({required super.campaignResponse, required super.referrals});

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {
  final HomeType type;
  HomeLoadingState({
    required this.type,
    required super.campaignResponse,
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
    required super.campaignResponse,
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
    required super.campaignResponse,
    required super.referrals,
  });

  @override
  List<Object> get props => [type, message];
}
