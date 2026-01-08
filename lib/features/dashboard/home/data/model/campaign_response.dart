class CampaignResponse {
  CampaignResponse({this.campaign});

  List<CampaignModel>? campaign;

  CampaignResponse.fromJson(Map<String, dynamic> json) {
    campaign = List<CampaignModel>.from(
      json["campaign"].map((e) => CampaignModel.fromJson(e)),
    );
  }
}

class CampaignModel {
  CampaignModel({
    required this.id,
    required this.name,
    required this.title,
    required this.url,
    required this.campaignEndDate,
  });

  int id;
  String name;
  String title;
  String url;
  DateTime campaignEndDate;

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      url: json['item_url'] ?? '',
      campaignEndDate: DateTime.parse(
        json['campaign_end_date'] ?? DateTime.now(),
      ),
    );
  }

  factory CampaignModel.empty() {
    return CampaignModel(
      id: 0,
      name: '',
      title: '',
      url: '',
      campaignEndDate: DateTime.now(),
    );
  }
}
