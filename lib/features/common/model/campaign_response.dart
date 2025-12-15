class CampaignResponse {
  CampaignResponse({this.campaign});

  List<Campaign>? campaign;

  CampaignResponse.fromJson(Map<String, dynamic> json) {
    campaign = List<Campaign>.from(
      json["campaign"].map((e) => Campaign.fromJson(e)),
    );
  }
}

class Campaign {
  Campaign({this.id, this.name, this.title, this.campaignEndDate, this.url});

  int? id;
  String? name;
  String? title;
  String? url;
  DateTime? campaignEndDate;

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['title'] != null) {
      title = json['title'];
    }
    if (json['item_url'] != null) {
      url = json['item_url'];
    }
    if (json['campaign_end_date'] != null) {
      campaignEndDate = DateTime.tryParse(json['campaign_end_date']);
    }
  }
}
