part of 'campaign_cubit.dart';

enum CampaignType { getCampaign, updateCampaign }

class CampaignState extends Equatable {
  final int totalParticipants;
  final List<UserProfile> referrals;
  final bool isUserInCampaign;

  CampaignState({
    required this.totalParticipants,
    required this.referrals,
    required this.isUserInCampaign,
  });

  CampaignState copyWith({
    int? totalParticipants,
    List<UserProfile>? referrals,
    bool? isUserInCampaign,
  }) {
    return CampaignState(
      totalParticipants: totalParticipants ?? this.totalParticipants,
      referrals: referrals ?? this.referrals,
      isUserInCampaign: isUserInCampaign ?? this.isUserInCampaign,
    );
  }

  @override
  List<Object?> get props => [totalParticipants, referrals, isUserInCampaign];
}

final class CampaignInitialState extends CampaignState {
  CampaignInitialState({
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
  });

  @override
  List<Object> get props => [];
}

class CampaignLoadingState extends CampaignState {
  final CampaignType type;

  CampaignLoadingState({
    required this.type,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
  });
  @override
  List<Object?> get props => [type];
}

class CampaignSuccessState extends CampaignState {
  final CampaignType type;
  final String message;
  final String? data;

  CampaignSuccessState({
    required this.type,
    required this.message,
    this.data,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
  });
  @override
  List<Object?> get props => [type, message, data];
}

class CampaignFailureState extends CampaignState {
  final CampaignType type;
  final String message;

  CampaignFailureState({
    required this.type,
    required this.message,
    required super.totalParticipants,
    required super.referrals,
    required super.isUserInCampaign,
  });
  @override
  List<Object?> get props => [type, message];
}
