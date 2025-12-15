part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class CampaignLoading extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CampaignLoaded extends HomeState {
  final CampaignResponse campaignResponse;

  CampaignLoaded(this.campaignResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [campaignResponse];
}
class CampaignFailure extends HomeState {
  final String err;

  CampaignFailure(this.err);

  List<Object?> get props => [err];
}
