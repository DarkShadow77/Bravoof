part of 'campaign_bloc.dart';

@immutable
sealed class CampaignEvent {}

class LoadTotalCampaignParticipants extends CampaignEvent {
  LoadTotalCampaignParticipants();
}

class LoadUserReferralsForCampaign extends CampaignEvent {
  LoadUserReferralsForCampaign();
}

class IsUserInCampaign extends CampaignEvent {
  IsUserInCampaign();
}

class HasUserClaimedReward extends CampaignEvent {
  HasUserClaimedReward();
}

class ClaimParticipantReward extends CampaignEvent {
  ClaimParticipantReward();
}

class ClaimWinnerReward extends CampaignEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String country;
  final String deliveryAddress;
  final String city;
  final String state;
  ClaimWinnerReward({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.country,
    required this.deliveryAddress,
    required this.city,
    required this.state,
  });
}
