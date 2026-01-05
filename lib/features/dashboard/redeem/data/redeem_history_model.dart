class RedeemHistory {
  final String id;
  final String rewardType;
  final int coinsSpent;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  RedeemHistory({
    required this.id,
    required this.rewardType,
    required this.coinsSpent,
    required this.metadata,
    required this.createdAt,
  });

  factory RedeemHistory.fromJson(Map<String, dynamic> json) {
    return RedeemHistory(
      id: json['id'] ?? "",
      rewardType: json['reward_type'] ?? "",
      coinsSpent: json['coins_spent'] ?? 0,
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now()),
    );
  }
}
