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
    required this.winnerName,
    required this.winnerProfileImage,
    required this.campaignEndDate,
    required this.claimed,
    required this.prizeDetails,
    required this.bgColor,
    required this.endBgColor,
    required this.cardTextColor,
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
  String prizeDetails;
  String bgColor;
  String endBgColor;
  String cardTextColor;

  factory CampaignResponseModel.fromJson(Map<String, dynamic> json) {
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
      winnerName: json['winner_name'] ?? '',
      winnerProfileImage: json['winner_profile_image'] ?? '',
      campaignEndDate: DateTime.parse(
        json['campaign_end_date'] ?? DateTime.now(),
      ),
      claimed: json['claimed'] ?? false,
      prizeDetails: json['prize_details'] ?? "",
      bgColor: json['bg_color'] ?? '#ffffff',
      endBgColor: json['end_bg_color'] ?? '#ffffff',
      cardTextColor: json['card_text_color'] ?? '#ffffff',
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
      winnerName: '',
      winnerProfileImage: '',
      campaignEndDate: DateTime.now(),
      claimed: false,
      prizeDetails: "",
      bgColor: '#ffffff',
      endBgColor: '#ffffff',
      cardTextColor: '#ffffff',
    );
  }
}
