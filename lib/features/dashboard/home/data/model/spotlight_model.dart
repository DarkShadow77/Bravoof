class SpotlightModel {
  final int id;
  final String title;
  final String name;
  final String image;
  final int missionsCompleted;
  final int coinsEarned;
  final int redeemed;
  final DateTime createdAt;

  SpotlightModel({
    required this.id,
    required this.title,
    required this.name,
    required this.image,
    required this.missionsCompleted,
    required this.coinsEarned,
    required this.redeemed,
    required this.createdAt,
  });

  factory SpotlightModel.fromJson(Map<String, dynamic> json) {
    return SpotlightModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      missionsCompleted: json['missions_completed'] ?? 0,
      coinsEarned: json['coins_earned'] ?? 0,
      redeemed: json['redeemed'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now()),
    );
  }

  factory SpotlightModel.empty() {
    return SpotlightModel(
      id: 0,
      title: '',
      name: '',
      image: '',
      missionsCompleted: 0,
      coinsEarned: 0,
      redeemed: 0,
      createdAt: DateTime.now(),
    );
  }
}
