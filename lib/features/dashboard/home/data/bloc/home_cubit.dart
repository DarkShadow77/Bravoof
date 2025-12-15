import 'package:bloc/bloc.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/home/data/repository/home_repository.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final homeRepository=HomeRepository();
  void fetchCampaigns()async {
    emit(CampaignLoading());

    final either  = await homeRepository.fetchCampaigns();

    either.fold(
          (failure) => emit(CampaignFailure(failure.toString())),
          (campaign) =>emit(CampaignLoaded(campaign)),
    );
  }
}
