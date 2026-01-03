part of 'redeem_bloc.dart';

@immutable
sealed class RedeemEvent {}

class RedeemAirtimeData extends RedeemEvent {
  final String rewardType;
  final String phone;
  final String userName;
  final int coins;

  RedeemAirtimeData({
    required this.rewardType,
    required this.phone,
    required this.userName,
    required this.coins,
  });
}

class RedeemGiftcard extends RedeemEvent {
  final String rewardType;
  final String phone;
  final String userName;
  final int coins;

  RedeemGiftcard({
    required this.rewardType,
    required this.phone,
    required this.userName,
    required this.coins,
  });
}
