class LeaderboardResponseModel {
  LeaderboardResponseModel({
    required this.leaderboard,
    required this.currentUser,
  });

  List<LeaderboardModel> leaderboard;
  CurrentUserModel currentUser;

  factory LeaderboardResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponseModel(
      leaderboard: List<LeaderboardModel>.from(
        (json["leaderboard"] ?? []).map((e) => LeaderboardModel.fromJson(e)),
      ),
      currentUser: CurrentUserModel.fromJson(json["current_user"] ?? {}),
    );
  }

  factory LeaderboardResponseModel.empty() {
    return LeaderboardResponseModel(
      leaderboard: [],
      currentUser: CurrentUserModel.empty(),
    );
  }
}

class LeaderboardModel {
  LeaderboardModel({
    required this.rank,
    required this.userId,
    required this.name,
    required this.bio,
    required this.profileImage,
    required this.totalEarned,
    required this.country,
    required this.city,
  });

  int rank;
  String userId;
  String name;
  String bio;
  String profileImage;
  int totalEarned;
  String country;
  String city;

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] ?? 0,
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profile_image'] ?? '',
      totalEarned: json['total_earned'] ?? 0,
      country: json['country'] ?? '',
      city: json['city'] ?? '',
    );
  }

  factory LeaderboardModel.empty() {
    return LeaderboardModel(
      rank: 0,
      userId: '',
      name: '',
      bio: '',
      profileImage: '',
      totalEarned: 0,
      country: '',
      city: '',
    );
  }
}

class CurrentUserModel {
  CurrentUserModel({
    required this.rank,
    required this.userId,
    required this.name,
    required this.totalEarned,
  });

  int rank;
  String userId;
  String name;
  int totalEarned;

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      rank: json['rank'] ?? 0,
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      totalEarned: json['total_earned'] ?? 0,
    );
  }

  factory CurrentUserModel.empty() {
    return CurrentUserModel(rank: 0, userId: '', name: '', totalEarned: 0);
  }
}
