import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../onbaording/data/model/user_profile.dart';
import '../../data/repository/campaign_repository.dart';

part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final int campaignId;
  final CampaignRepository repo;
  final supabase = Supabase.instance.client;

  CampaignBloc({required this.campaignId, required this.repo})
    : super(
        CampaignInitialState(
          totalParticipants: 0,
          referrals: [],
          isUserInCampaign: false,
          hasClaimed: true,
        ),
      ) {
    on<LoadTotalCampaignParticipants>(_loadTotalCampaignParticipants);
    on<LoadUserReferralsForCampaign>(_loadUserReferralsForCampaign);
    on<IsUserInCampaign>(_isUserInCampaign);
    on<HasUserClaimedReward>(_hasUserClaimedReward);
    on<ClaimParticipantReward>(_claimParticipantReward);
    on<ClaimWinnerReward>(claimWinnerReward);
  }

  Future<void> _loadTotalCampaignParticipants(
    LoadTotalCampaignParticipants event,
    Emitter emit,
  ) async {
    final result = await repo.getTotalJoinedForCampaign(campaignId: campaignId);

    result.fold(
      (error) => print(error),
      (count) => emit(state.copyWith(totalParticipants: count)),
    );
  }

  Future<void> _loadUserReferralsForCampaign(
    LoadUserReferralsForCampaign event,
    Emitter emit,
  ) async {
    final res = await repo.getUserReferralsForCampaign(
      userId: supabase.auth.currentUser!.id,
      campaignId: campaignId,
    );

    res.fold(
      (err) => print(err),
      (list) => emit(state.copyWith(referrals: list)),
    );
  }

  Future<void> _isUserInCampaign(IsUserInCampaign event, Emitter emit) async {
    final res = await repo.isUserInCampaign(
      campaignId: campaignId,
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (err) => print(err),
      (isJoined) => emit(state.copyWith(isUserInCampaign: isJoined)),
    );
  }

  Future<void> _hasUserClaimedReward(
    HasUserClaimedReward event,
    Emitter emit,
  ) async {
    final res = await repo.hasUserClaimedReward(
      campaignId: campaignId,
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (err) => print(err),
      (hasClaimed) => emit(state.copyWith(hasClaimed: hasClaimed)),
    );
  }

  Future<void> _claimParticipantReward(
    ClaimParticipantReward event,
    Emitter emit,
  ) async {
    emit(
      CampaignLoadingState(
        type: CampaignType.claimReward,
        totalParticipants: state.totalParticipants,
        referrals: state.referrals,
        isUserInCampaign: state.isUserInCampaign,
        hasClaimed: state.hasClaimed,
      ),
    );

    final res = await repo.claimParticipantReward(
      campaignId: campaignId,
      userId: supabase.auth.currentUser!.id,
    );

    res.fold(
      (err) => emit(
        CampaignFailureState(
          message: err,
          type: CampaignType.claimReward,
          totalParticipants: state.totalParticipants,
          referrals: state.referrals,
          isUserInCampaign: state.isUserInCampaign,
          hasClaimed: state.hasClaimed,
        ),
      ),
      (success) => emit(
        CampaignSuccessState(
          message: success,
          type: CampaignType.claimReward,
          totalParticipants: state.totalParticipants,
          referrals: state.referrals,
          isUserInCampaign: state.isUserInCampaign,
          hasClaimed: true,
        ),
      ),
    );
  }

  Future<void> claimWinnerReward(ClaimWinnerReward event, Emitter emit) async {
    emit(
      CampaignLoadingState(
        type: CampaignType.claimWinnerReward,
        totalParticipants: state.totalParticipants,
        referrals: state.referrals,
        isUserInCampaign: state.isUserInCampaign,
        hasClaimed: state.hasClaimed,
      ),
    );

    final res = await repo.claimWinnerReward(
      campaignId: campaignId,
      userId: supabase.auth.currentUser!.id,
      firstName: event.firstName,
      lastName: event.lastName,
      phoneNumber: event.phoneNumber,
      country: event.country,
      deliveryAddress: event.deliveryAddress,
      city: event.city,
      state: event.state,
    );

    res.fold(
      (err) => emit(
        CampaignFailureState(
          message: err,
          type: CampaignType.claimWinnerReward,
          totalParticipants: state.totalParticipants,
          referrals: state.referrals,
          isUserInCampaign: state.isUserInCampaign,
          hasClaimed: state.hasClaimed,
        ),
      ),
      (success) => emit(
        CampaignSuccessState(
          message: success,
          type: CampaignType.claimWinnerReward,
          totalParticipants: state.totalParticipants,
          referrals: state.referrals,
          isUserInCampaign: state.isUserInCampaign,
          hasClaimed: true,
        ),
      ),
    );
  }
}
