class UserProfile {
  String id;
  String userId;
  String name;
  String email;
  String pass;
  String fullName;
  bool isLogin;
  String interest;
  List<String> goals;
  String profilePic;
  String referralCode;
  String referrerEmail;
  String referrerName;
  int referralCount;
  int totalPoints;
  int totalEarned;
  int totalSpent;
  int basePoints;
  int currentStreak;
  bool isBanned;
  bool isAuthenticated;
  DateTime createdAt;
  String bio;
  int spins;
  int missionsCompleted;
  String coverPic;
  String country;
  String city;
  String flag;
  String countryCode;
  String countryCodeIso3;
  AuthProviders authProviders;
  Map<String, dynamic> providerEmails;
  List<String> allEmails;
  String primaryEmail;
  bool hasPassword;

  UserProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.bio,
    required this.email,
    required this.pass,
    required this.fullName,
    required this.isLogin,
    required this.referralCode,
    required this.referrerEmail,
    required this.referrerName,
    required this.profilePic,
    required this.totalPoints,
    required this.totalEarned,
    required this.totalSpent,
    required this.missionsCompleted,
    required this.basePoints,
    required this.referralCount,
    required this.spins,
    required this.currentStreak,
    required this.isBanned,
    required this.isAuthenticated,
    required this.createdAt,
    required this.interest,
    required this.goals,
    required this.coverPic,
    required this.country,
    required this.city,
    required this.flag,
    required this.countryCode,
    required this.countryCodeIso3,
    required this.authProviders,
    required this.providerEmails,
    required this.allEmails,
    required this.primaryEmail,
    required this.hasPassword,
  });

  factory UserProfile.empty() {
    return UserProfile(
      id: '',
      userId: '',
      name: '',
      bio: '',
      email: '',
      pass: '',
      fullName: '',
      isLogin: false,
      referralCode: '',
      referrerEmail: '',
      referrerName: '',
      profilePic: '',
      totalPoints: 0,
      totalEarned: 0,
      totalSpent: 0,
      missionsCompleted: 0,
      basePoints: 1,
      referralCount: 0,
      spins: 0,
      currentStreak: 0,
      isBanned: false,
      isAuthenticated: false,
      createdAt: DateTime.now(),
      interest: '',
      goals: const [],
      coverPic: "",
      country: "",
      city: "",
      flag: "",
      countryCode: "",
      countryCodeIso3: "",
      authProviders: AuthProviders.empty(),
      providerEmails: const {},
      allEmails: const [],
      primaryEmail: '',
      hasPassword: false,
    );
  }

  UserProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    String? pass,
    String? fullName,
    String? email,
    bool? isLogin,
    String? referralCode,
    String? referrerEmail,
    String? referrerName,
    String? profilePic,
    int? totalPoints,
    int? totalEarned,
    int? totalSpent,
    int? missionsCompleted,
    int? basePoints,
    int? referralCount,
    int? spins,
    int? currentStreak,
    bool? isBanned,
    bool? isAuthenticated,
    DateTime? createdAt,
    List<String>? stack,
    String? interest,
    List<String>? goals,
    String? coverPic,
    String? country,
    String? city,
    String? flag,
    String? countryCode,
    String? countryCodeIso3,
    AuthProviders? authProviders,
    Map<String, dynamic>? providerEmails,
    List<String>? allEmails,
    String? primaryEmail,
    bool? hasPassword,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      pass: pass ?? this.pass,
      fullName: fullName ?? this.fullName,
      isLogin: isLogin ?? this.isLogin,
      referralCode: referralCode ?? this.referralCode,
      referrerEmail: referrerEmail ?? this.referrerEmail,
      referrerName: referrerName ?? this.referrerName,
      profilePic: profilePic ?? this.profilePic,
      totalPoints: totalPoints ?? this.totalPoints,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      missionsCompleted: missionsCompleted ?? this.missionsCompleted,
      basePoints: basePoints ?? this.basePoints,
      referralCount: referralCount ?? this.referralCount,
      spins: spins ?? this.spins,
      currentStreak: currentStreak ?? this.currentStreak,
      isBanned: isBanned ?? this.isBanned,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      createdAt: createdAt ?? this.createdAt,
      interest: interest ?? this.interest,
      goals: goals ?? this.goals,
      coverPic: coverPic ?? this.coverPic,
      country: country ?? this.country,
      city: city ?? this.city,
      flag: flag ?? this.flag,
      countryCode: countryCode ?? this.countryCode,
      countryCodeIso3: countryCodeIso3 ?? this.countryCodeIso3,
      authProviders: authProviders ?? this.authProviders,
      providerEmails: providerEmails ?? this.providerEmails,
      allEmails: allEmails ?? this.allEmails,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      hasPassword: hasPassword ?? this.hasPassword,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? '',
      name: json['name'] ?? "",
      email: json['email'] ?? '',
      pass: json['pass'] ?? '',
      fullName: json['full_name'] ?? '',
      isLogin: json['isLogin'] ?? false,
      interest: json['interest'] ?? "",
      goals:
          (json['goals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      profilePic: json['profile_image'] ?? '',
      referralCode: json['referral_code'] ?? "",
      referrerEmail: json['referrer_email'] ?? "",
      referrerName: json['referrer_name'] ?? '',
      referralCount: json['referral_count'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      totalEarned: json['total_earned'] ?? 0,
      totalSpent: json['total_spent'] ?? 0,
      basePoints: json['base_point'] ?? 1,
      currentStreak: json['current_streak'] ?? 0,
      isBanned: json['is_banned'] ?? false,
      isAuthenticated: json['is_authenticated'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      bio: json['bio'] ?? '',
      spins: json['spins'] ?? 0,
      missionsCompleted: json['missions_completed'] ?? 0,
      coverPic: json['cover_pic'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      flag: json['flag'] ?? '',
      countryCode: json['country_code'] ?? '',
      countryCodeIso3: json['country_code_iso3'] ?? '',
      authProviders: json['auth_providers'] != null
          ? AuthProviders.fromJson(
              json['auth_providers'] as Map<String, dynamic>,
            )
          : AuthProviders.empty(),
      providerEmails: json['provider_emails'] as Map<String, dynamic>? ?? {},
      allEmails:
          (json['all_emails'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      primaryEmail: json['primary_email'] ?? '',
      hasPassword: json['has_password'] ?? false,
    );
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

class AuthProviders {
  bool apple;
  bool email;
  bool google;

  AuthProviders({
    required this.apple,
    required this.email,
    required this.google,
  });

  factory AuthProviders.empty() {
    return AuthProviders(apple: false, email: false, google: false);
  }

  AuthProviders copyWith({bool? apple, bool? email, bool? google}) {
    return AuthProviders(
      apple: apple ?? this.apple,
      email: email ?? this.email,
      google: google ?? this.google,
    );
  }

  factory AuthProviders.fromJson(Map<String, dynamic> json) {
    return AuthProviders(
      apple: json['apple'] ?? false,
      email: json['email'] ?? false,
      google: json['google'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'apple': apple, 'email': email, 'google': google};
  }

  // Helper methods
  bool get hasAnyProvider => apple || email || google;

  List<String> get activeProviders {
    List<String> providers = [];
    if (apple) providers.add('apple');
    if (email) providers.add('email');
    if (google) providers.add('google');
    return providers;
  }

  bool canUnlink(String provider) {
    return hasAnyProvider;
  }
}
