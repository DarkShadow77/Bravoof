import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../session/session_manager.dart';
import '../../../../onbaording/data/model/user_profile.dart';
import '../../data/repository/campaign_repository.dart';

part 'campaign_state.dart';

class CampaignCubit extends Cubit<CampaignState> {
  final int campaignId;
  final CampaignRepository campaignRepository;

  CampaignCubit({required this.campaignId, required this.campaignRepository})
    : super(
        CampaignInitialState(
          totalParticipants: 0,
          referrals: [],
          isUserInCampaign: false,
        ),
      ) {
    getTotalCampaignParticipants();
    getUserReferralsForCampaign();
    isUserInCampaign();
  }

  void getTotalCampaignParticipants() async {
    final result = await campaignRepository.getTotalJoinedForCampaign(
      campaignId: campaignId,
    );

    result.fold((error) => print(error), (count) {
      log('Total joined: $count');
      emit(state.copyWith(totalParticipants: count));
    });
  }

  void getUserReferralsForCampaign() async {
    final res = await campaignRepository.getUserReferralsForCampaign(
      userId: SessionManager().userIdVal,
      campaignId: campaignId,
    );

    res.fold((err) => print(err), (list) {
      print('Referrals: ${list.map((e) => e.toJson())}');
      emit(state.copyWith(referrals: list));
    });
  }

  void isUserInCampaign() async {
    final isJoined = await campaignRepository.isUserInCampaign(
      campaignId: campaignId,
      userId: SessionManager().userIdVal,
    );

    if (isJoined) {
      print("User is already in the campaign");
    } else {
      print("User is NOT in the campaign");
    }

    emit(state.copyWith(isUserInCampaign: isJoined));
  }
}
