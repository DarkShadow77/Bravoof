class UserProfile {
  String? id;
  String? userId;
  String? name;
  String? bio;
  String? pass;
  String? fullName;
  String? email;
  bool? isLogin;
  String? referralCode;
  String? referrerEmail;
  String? referrerName;
  String? profilePic;
  int? totalPoints;
  int? basePoints;
  int? referralCount;
  int? currentStreak;
  bool? isBanned;
  bool? isAuthenticated;
  DateTime? createdAt;
  List<String>? stack;
  String? interest;
  List<String>? goals;

  UserProfile({
    this.id,
    this.name,
    this.bio,
    this.pass,
    this.fullName,
    this.email,
    this.isLogin,
    this.referrerName,
    this.referrerEmail,
    this.referralCode,
    this.referralCount,
    this.profilePic,
    this.stack,
    this.interest,
    this.goals,
    this.currentStreak,
    this.totalPoints,
    this.basePoints,
    this.isBanned,
    this.isAuthenticated,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['user_id'] != null) {
      userId = json['user_id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['bio'] != null) {
      bio = json['bio'];
    }
    if (json['full_name'] != null) {
      fullName = json['full_name'];
    }

    if (json['email'] != null) {
      email = json['email'];
    }

    if (json['interest'] != null) {
      interest = json['interest'];
    }
    if (json['tools'] != null) {
      stack =
          (json['tools'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
    }
    if (json['goals'] != null) {
      goals =
          (json['goals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
    }
    if (json['profile_image'] != null) {
      profilePic = json['profile_image'];
    }
    if (json['total_points'] != null) {
      totalPoints = json['total_points'];
    }
    if (json['base_point'] != null) {
      basePoints = json['base_point'];
    }
    if (json['referral_count'] != null) {
      referralCount = json['referral_count'];
    }
    if (json['referral_code'] != null) {
      referralCode = json['referral_code'];
    }
    if (json['current_streak'] != null) {
      currentStreak = json['current_streak'];
    }
    if (json['referrer_email'] != null) {
      referrerEmail = json['referrer_email'];
    }
    if (json['referrer_name'] != null) {
      referrerName = json['referrer_name'];
    }
    if (json['is_banned'] != null) {
      isBanned = json['is_banned'];
    }
    if (json['is_authenticated'] != null) {
      isAuthenticated = json['is_authenticated'];
    }
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (name != null && name!.isNotEmpty) {
      data["name"] = name;
    }
    if (isLogin != null) {
      data["isLogin"] = isLogin;
    }

    if (bio != null && bio!.isNotEmpty) {
      data["bio"] = bio;
    }
    if (pass != null) {
      data['pass'] = pass;
    }
    if (fullName != null && fullName!.isNotEmpty) {
      data["full_name"] = fullName;
    }
    if (email != null && email!.isNotEmpty) {
      data["email"] = email;
    }
    if (goals != null) {
      data["goals"] = goals;
    }
    if (referralCount != null) {
      data["referral_count"] = referralCount;
    }
    if (referralCode != null) {
      data["referral_code"] = referralCode;
    }
    if (profilePic != null) {
      data["profile_image"] = profilePic;
    }
    if (userId != null) {
      data["user_id"] = userId;
    }
    return data;
  }
}
