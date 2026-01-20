import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';

class RewardsSummaryResponse {
  List<RewardsSummary>? rewardsSummary;
  RewardsSummaryResponse({this.rewardsSummary});
  RewardsSummaryResponse.fromJson(Map<String, dynamic> json) {
    rewardsSummary = List<RewardsSummary>.from(
      json['rewards'].map((e) => RewardsSummary.fromJson(e)),
    );
  }
}

class RewardsSummary {
  RewardsSummary({this.totalPointRedeemed, this.userId, this.userProfile});
  int? totalPointRedeemed;
  String? userId;
  UserProfile? userProfile;
  RewardsSummary.fromJson(Map<String, dynamic> json) {
    if (json['total_point_redeemed'] != null) {
      totalPointRedeemed = json['total_point_redeemed'];
    }
    if (json['user_id'] != null) {
      userId = json['user_id'];
    }
    if (json['user_profile'] != null) {
      userProfile = UserProfile.fromJson(json['user_profile']);
    }
  }
}
