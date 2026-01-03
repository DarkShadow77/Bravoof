import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../../../session/session_manager.dart';
import '../../data/repository/redeem_repository.dart';

part 'redeem_event.dart';
part 'redeem_state.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  final RedeemRepository repo;
  SessionManager session = SessionManager();

  RedeemBloc({required this.repo}) : super(RedeemInitialState()) {
    on<RedeemAirtimeData>(_redeemAirtimeData);
    on<RedeemGiftcard>(_redeemGiftcard);
  }

  Future<void> _redeemAirtimeData(RedeemAirtimeData event, Emitter emit) async {
    emit(RedeemLoadingState(type: RedeemType.redeemAirtimeData));

    final res = await repo.redeemAirtimeData(
      userId: session.userIdVal,
      coins: event.coins,
      phone: event.phone,
      rewardType: event.rewardType,
      userName: event.userName,
    );

    Logger().d("Redeem Airtime and Data Response $res");

    res.fold(
      (err) => emit(
        RedeemFailureState(type: RedeemType.redeemAirtimeData, message: err),
      ),
      (success) => emit(
        RedeemSuccessState(
          type: RedeemType.redeemAirtimeData,
          message: success,
        ),
      ),
    );
  }

  Future<void> _redeemGiftcard(RedeemGiftcard event, Emitter emit) async {
    emit(RedeemLoadingState(type: RedeemType.redeemGiftcard));

    final res = await repo.redeemGiftcard(
      userId: session.userIdVal,
      coins: event.coins,
      phone: event.phone,
      rewardType: event.rewardType,
      userName: event.userName,
    );

    Logger().d("Redeem GiftCard Response $res");

    res.fold(
      (err) => emit(
        RedeemFailureState(type: RedeemType.redeemGiftcard, message: err),
      ),
      (success) => emit(
        RedeemSuccessState(type: RedeemType.redeemGiftcard, message: success),
      ),
    );
  }
}
