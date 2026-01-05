part of 'redeem_bloc.dart';

@immutable
sealed class RedeemEvent {}

class LoadRedeemHistory extends RedeemEvent {}

class RedeemAirtimeData extends RedeemEvent {
  final String rewardType;
  final String phone;
  final String userName;
  final String email;
  final int coins;

  RedeemAirtimeData({
    required this.rewardType,
    required this.phone,
    required this.userName,
    required this.email,
    required this.coins,
  });
}

class RedeemGiftcard extends RedeemEvent {
  final String rewardType;
  final String phone;
  final String userName;
  final String email;
  final int coins;

  RedeemGiftcard({
    required this.rewardType,
    required this.phone,
    required this.userName,
    required this.email,
    required this.coins,
  });
}
