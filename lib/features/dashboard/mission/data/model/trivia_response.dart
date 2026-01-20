class TriviaResponse {
  List<Trivia>? trivia;
  TriviaResponse({this.trivia});
  TriviaResponse.fromJson(Map<String, dynamic> json) {
    trivia = List<Trivia>.from(json['trivia'].map((e) => Trivia.fromJson(e)));
  }
}

class Trivia {
  Trivia({
    this.profileImage,
    this.name,
    this.userId,
    this.totalPoints,
    this.userRank,
    this.hasMedal,
  });

  String? profileImage;
  String? name;
  String? userId;
  int? totalPoints;
  int? userRank;
  bool? hasMedal;

  Trivia.fromJson(Map<String, dynamic> json) {
    if (json['profile_image'] != null) {
      profileImage = json['profile_image'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['user_id'] != null) {
      userId = json['user_id'];
    }

    if (json['total_points'] != null) {
      totalPoints = json['total_points'];
    }
    if (json['user_rank'] != null) {
      userRank = json['user_rank'];
    }
    if (json['has_medal'] != null) {
      hasMedal = json['has_medal'];
    }
  }
}
