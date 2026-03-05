class CampaignResponseModel {
  CampaignResponseModel({
    required this.id,
    required this.name,
    required this.title,
    required this.item,
    required this.brandImage,
    required this.innerTitle,
    required this.instructions,
    required this.url,
    required this.winnerUserId,
    required this.isMultipleWinner,
    required this.numberOfWinners,
    required this.winnerUserIds,
    required this.winners, // NEW
    required this.rewardList, // NEW
    required this.winnerName,
    required this.winnerProfileImage,
    required this.campaignEndDate,
    required this.claimed,
    required this.isDelivery,
    required this.prizeDetails,
    required this.bgColor,
    required this.endBgColor,
    required this.cardTextColor,
    required this.textColor,
    required this.inverseTextColor,
    required this.month,
  });

  int id;
  String name;
  String title;
  String item;
  String brandImage;
  String innerTitle;
  List<String> instructions;
  String url;
  String winnerUserId;
  String winnerName;
  String winnerProfileImage;
  DateTime campaignEndDate;
  bool claimed;
  bool isDelivery;
  String prizeDetails;
  String bgColor;
  String endBgColor;
  String cardTextColor;
  String textColor;
  String inverseTextColor;
  String month;
  bool isMultipleWinner;
  int numberOfWinners;
  List<String> winnerUserIds;
  List<CampaignWinner> winners; // NEW: Full winner details
  List<CampaignReward> rewardList; // NEW: Reward list

  factory CampaignResponseModel.fromJson(Map<String, dynamic> json) {
    // Parse winner IDs
    List<String> winnerIds = [];
    if (json['winner_user_ids'] != null) {
      winnerIds = (json['winner_user_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } else if (json['winner_user_id'] != null &&
        json['winner_user_id'].toString().isNotEmpty) {
      winnerIds = [json['winner_user_id'].toString()];
    }

    // Parse full winner details
    List<CampaignWinner> winners = [];
    if (json['winners'] != null) {
      winners = (json['winners'] as List<dynamic>)
          .map((w) => CampaignWinner.fromJson(w))
          .toList();
    }

    // Parse reward list
    List<CampaignReward> rewards = [];
    if (json['reward_list'] != null) {
      rewards = (json['reward_list'] as List<dynamic>)
          .map((r) => CampaignReward.fromJson(r))
          .toList();
    }

    return CampaignResponseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      item: json['item'] ?? '',
      brandImage: json['brand_image'] ?? '',
      innerTitle: json['inner_title'] ?? '',
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      url: json['item_url'] ?? '',
      winnerUserId: json['winner_user_id'] ?? '',
      isMultipleWinner: json['is_multiple_winner'] ?? false,
      numberOfWinners: json['no_of_winners'] ?? 1,
      winnerUserIds: winnerIds,
      winners: winners,
      rewardList: rewards,
      winnerName: json['winner_name'] ?? '',
      winnerProfileImage: json['winner_profile_image'] ?? '',
      campaignEndDate: DateTime.parse(
        json['campaign_end_date'] ?? DateTime.now().toIso8601String(),
      ),
      claimed: json['claimed'] ?? false,
      isDelivery: json['is_delivery'] ?? false,
      prizeDetails: json['prize_details'] ?? "",
      bgColor: json['bg_color'] ?? '#ffffff',
      endBgColor: json['end_bg_color'] ?? '#ffffff',
      cardTextColor: json['card_text_color'] ?? '#ffffff',
      textColor: json['text_color'] ?? '#ffffff',
      inverseTextColor: json['inverse_text_color'] ?? '#000000',
      month: json['month'] ?? '',
    );
  }

  factory CampaignResponseModel.empty() {
    return CampaignResponseModel(
      id: 0,
      name: '',
      title: '',
      item: '',
      brandImage: '',
      innerTitle: '',
      instructions: [],
      url: '',
      winnerUserId: '',
      isMultipleWinner: false,
      numberOfWinners: 0,
      winnerUserIds: [],
      winners: [],
      rewardList: [],
      winnerName: '',
      winnerProfileImage: '',
      campaignEndDate: DateTime.now(),
      claimed: false,
      isDelivery: false,
      prizeDetails: "",
      bgColor: '#ffffff',
      endBgColor: '#ffffff',
      cardTextColor: '#ffffff',
      textColor: '#ffffff',
      inverseTextColor: '#000000',
      month: '',
    );
  }

  // Helper to check if current user is a winner
  bool isUserWinner(String userId) {
    return winnerUserIds.contains(userId);
  }

  // Helper to get current user's winner details
  CampaignWinner? getWinnerDetails(String userId) {
    try {
      return winners.firstWhere((w) => w.userId == userId);
    } catch (e) {
      return null;
    }
  }
}

// NEW: Winner details model
class CampaignWinner {
  final String userId;
  final String name;
  final String profileImage;
  final String bio;
  final int totalEarned;

  CampaignWinner({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.totalEarned,
  });

  factory CampaignWinner.fromJson(Map<String, dynamic> json) {
    return CampaignWinner(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      bio: json['bio'] ?? '',
      totalEarned: json['total_earned'] ?? 0,
    );
  }
}

// NEW: Reward model
class CampaignReward {
  final String name;
  final String image;

  CampaignReward({required this.name, required this.image});

  factory CampaignReward.fromJson(Map<String, dynamic> json) {
    return CampaignReward(name: json['name'] ?? '', image: json['image'] ?? '');
  }
}
