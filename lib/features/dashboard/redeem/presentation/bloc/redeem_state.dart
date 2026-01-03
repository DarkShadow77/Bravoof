part of 'redeem_bloc.dart';

enum RedeemType { redeemAirtimeData, redeemGiftcard }

@immutable
sealed class RedeemState {}

final class RedeemInitialState extends RedeemState {}

class RedeemLoadingState extends RedeemState {
  final RedeemType type;
  RedeemLoadingState({required this.type});
}

class RedeemFailureState extends RedeemState {
  final String message;
  final RedeemType type;
  RedeemFailureState({required this.message, required this.type});
}

class RedeemSuccessState extends RedeemState {
  final String message;
  final RedeemType type;
  RedeemSuccessState({required this.message, required this.type});
}
