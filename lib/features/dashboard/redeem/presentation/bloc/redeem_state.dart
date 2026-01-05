part of 'redeem_bloc.dart';

enum RedeemType { fetchRedeemHistory, redeemAirtimeData, redeemGiftcard }

@immutable
class RedeemState {
  final List<RedeemHistory> redeemHistory;

  RedeemState({required this.redeemHistory});

  RedeemState copWith({List<RedeemHistory>? redeemHistory}) {
    return RedeemState(redeemHistory: redeemHistory ?? this.redeemHistory);
  }
}

class RedeemInitialState extends RedeemState {
  RedeemInitialState({required super.redeemHistory});
}

class RedeemLoadingState extends RedeemState {
  final RedeemType type;
  RedeemLoadingState({required this.type, required super.redeemHistory});
}

class RedeemFailureState extends RedeemState {
  final String message;
  final RedeemType type;
  RedeemFailureState({
    required this.message,
    required this.type,
    required super.redeemHistory,
  });
}

class RedeemSuccessState extends RedeemState {
  final String message;
  final RedeemType type;
  RedeemSuccessState({
    required this.message,
    required this.type,
    required super.redeemHistory,
  });
}
