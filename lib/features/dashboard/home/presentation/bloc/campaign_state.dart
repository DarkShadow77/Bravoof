part of 'campaign_bloc.dart';

enum CampaignType { claimReward, claimWinnerReward }

class CampaignState extends Equatable {
  final int totalParticipants;
  final List<Users> referrals;
  final bool isUserInCampaign;
  final bool hasClaimed;

  const CampaignState({
    required this.totalParticipants,
    required this.referrals,
    required this.isUserInCampaign,
    required this.hasClaimed,
  });

  CampaignState copyWith({
    int? totalParticipants,
    List<Users>? referrals,
    bool? isUserInCampaign,
    bool? hasClaimed,
  }) {
    return CampaignState(
      totalParticipants: totalParticipants ?? this.totalParticipants,
      referrals: referrals ?? this.referrals,
      isUserInCampaign: isUserInCampaign ?? this.isUserInCampaign,
      hasClaimed: hasClaimed ?? this.hasClaimed,
    );
  }

  @override
  List<Object?> get props => [
    totalParticipants,
    referrals,
    isUserInCampaign,
    hasClaimed,
  ];
}

final class CampaignInitialState extends CampaignState {
  CampaignInitialState({
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
    required super.hasClaimed,
  });

  @override
  List<Object> get props => [];
}

class CampaignLoadingState extends CampaignState {
  final CampaignType type;

  const CampaignLoadingState({
    required this.type,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
    required super.hasClaimed,
  });

  @override
  List<Object?> get props => [type];
}

class CampaignSuccessState extends CampaignState {
  final CampaignType type;
  final String message;
  final String? data;

  const CampaignSuccessState({
    required this.type,
    required this.message,
    this.data,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
    required super.hasClaimed,
  });

  @override
  List<Object?> get props => [type, message, data];
}

class CampaignFailureState extends CampaignState {
  final CampaignType type;
  final String message;

  const CampaignFailureState({
    required this.type,
    required this.message,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
    required super.hasClaimed,
  });

  @override
  List<Object?> get props => [type, message];
}
