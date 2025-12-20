import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/home/data/repository/home_repository.dart';
import 'package:meta/meta.dart';

import '../../../../../session/session_manager.dart';
import '../../../../onbaording/data/model/user_profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository})
    : super(
        HomeInitialState(campaignResponse: CampaignResponse(), referrals: []),
      );

  void fetchCampaigns() async {
    emit(
      HomeLoadingState(
        type: HomeType.getCampaign,
        campaignResponse: state.campaignResponse,
        referrals: state.referrals,
      ),
    );

    final either = await homeRepository.fetchCampaigns();

    either.fold(
      (failure) => emit(
        HomeFailureState(
          type: HomeType.getCampaign,
          message: failure.toString(),
          campaignResponse: state.campaignResponse,
          referrals: state.referrals,
        ),
      ),
      (campaign) {
        emit(state.copyWith(campaignResponse: campaign));
        emit(
          HomeSuccessState(
            type: HomeType.getCampaign,
            message: "Campaign Got Successfully",
            campaignResponse: campaign,
            referrals: state.referrals,
          ),
        );
      },
    );
  }

  void getUserReferrals() async {
    final res = await homeRepository.getAllUserReferrals(
      userId: SessionManager().userIdVal,
    );

    res.fold((err) => print(err), (list) {
      print('Referrals: ${list.map((e) => e.toJson())}');
      emit(state.copyWith(referrals: list));
    });
  }
}
