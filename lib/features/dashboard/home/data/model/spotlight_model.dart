class SpotlightModel {
  final int id;
  final String name;
  final String image;
  final int missions_completed;
  final int coins_earned;
  final int redeemed;
  final DateTime createdAt;

  SpotlightModel({
    required this.id,
    required this.name,
    required this.image,
    required this.missions_completed,
    required this.coins_earned,
    required this.redeemed,
    required this.createdAt,
  });

  factory SpotlightModel.fromJson(Map<String, dynamic> json) {
    return SpotlightModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      missions_completed: json['missions_completed'] ?? 0,
      coins_earned: json['coins_earned'] ?? 0,
      redeemed: json['redeemed'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now()),
    );
  }

  factory SpotlightModel.empty() {
    return SpotlightModel(
      id: 0,
      name: '',
      image: '',
      missions_completed: 0,
      coins_earned: 0,
      redeemed: 0,
      createdAt: DateTime.now(),
    );
  }
}
