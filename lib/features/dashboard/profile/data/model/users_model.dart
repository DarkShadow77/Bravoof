class Users {
  final String userId;
  final String name;
  final String profileImage;
  final String bio;
  final int totalEarned;
  final DateTime createdAt;

  Users({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.totalEarned,
    required this.createdAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      bio: json['bio'] ?? '',
      totalEarned: json['total_earned'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['user_id'] = userId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['bio'] = bio;
    data['total_earned'] = totalEarned;
    data['created_at'] = createdAt;
    return data;
  }
}
