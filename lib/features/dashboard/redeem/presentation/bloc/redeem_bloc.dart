import 'package:Bravoo/features/dashboard/redeem/data/redeem_history_model.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repository/redeem_repository.dart';

part 'redeem_event.dart';
part 'redeem_state.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  final RedeemRepository repo;

  final supabase = Supabase.instance.client;

  RedeemBloc({required this.repo})
    : super(RedeemInitialState(redeemHistory: [])) {
    on<LoadRedeemHistory>(_loadMission);
    on<RedeemAirtimeData>(_redeemAirtimeData);
    on<RedeemGiftcard>(_redeemGiftcard);
  }

  Future<void> _loadMission(LoadRedeemHistory event, Emitter emit) async {
    emit(
      RedeemLoadingState(
        type: RedeemType.fetchRedeemHistory,
        redeemHistory: state.redeemHistory,
      ),
    );

    final redeemRes = await repo.fetchRedeemHistory(
      userId: supabase.auth.currentUser!.id,
    );

    redeemRes.fold(
      (err) => emit(
        RedeemFailureState(
          type: RedeemType.fetchRedeemHistory,
          message: err,
          redeemHistory: state.redeemHistory,
        ),
      ),
      (redeemHistory) {
        emit(state.copWith(redeemHistory: redeemHistory));

        emit(
          RedeemSuccessState(
            type: RedeemType.fetchRedeemHistory,
            message: "Redeem History Fetched Successfully",
            redeemHistory: redeemHistory,
          ),
        );
      },
    );
  }

  Future<void> _redeemAirtimeData(RedeemAirtimeData event, Emitter emit) async {
    emit(
      RedeemLoadingState(
        type: RedeemType.redeemAirtimeData,
        redeemHistory: state.redeemHistory,
      ),
    );

    final res = await repo.redeemAirtimeData(
      userId: supabase.auth.currentUser!.id,
      coins: event.coins,
      phone: event.phone,
      network: event.network,
      rewardType: event.rewardType,
      userName: event.userName,
      email: event.email,
    );

    Logger().d("Redeem Airtime and Data Response $res");

    res.fold(
      (err) => emit(
        RedeemFailureState(
          type: RedeemType.redeemAirtimeData,
          message: err,
          redeemHistory: state.redeemHistory,
        ),
      ),
      (success) => emit(
        RedeemSuccessState(
          type: RedeemType.redeemAirtimeData,
          message: success,
          redeemHistory: state.redeemHistory,
        ),
      ),
    );
  }

  Future<void> _redeemGiftcard(RedeemGiftcard event, Emitter emit) async {
    emit(
      RedeemLoadingState(
        type: RedeemType.redeemGiftcard,
        redeemHistory: state.redeemHistory,
      ),
    );

    final res = await repo.redeemGiftcard(
      userId: supabase.auth.currentUser!.id,
      coins: event.coins,
      phone: event.phone,
      rewardType: event.rewardType,
      userName: event.userName,
      email: event.email,
    );

    Logger().d("Redeem GiftCard Response $res");

    res.fold(
      (err) => emit(
        RedeemFailureState(
          type: RedeemType.redeemGiftcard,
          message: err,
          redeemHistory: state.redeemHistory,
        ),
      ),
      (success) => emit(
        RedeemSuccessState(
          type: RedeemType.redeemGiftcard,
          message: success,
          redeemHistory: state.redeemHistory,
        ),
      ),
    );
  }
}
