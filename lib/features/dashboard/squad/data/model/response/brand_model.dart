import 'package:bravoo/features/dashboard/mission/data/model/featured_mission_model.dart';

import '../../../../profile/data/model/users_model.dart';

class Brand {
  final String id;
  final String name;
  final String about;
  final String logo;
  final String logoBgColor;
  final MissionGradient gradientColor;
  final String textColor;
  final String inverseTextColor;
  final bool active;
  final DateTime createdAt;
  final int missionCount;
  final int followerCount;
  final List<Users> followers;
  final bool isFollowing;

  Brand({
    required this.id,
    required this.name,
    required this.about,
    required this.logo,
    required this.logoBgColor,
    required this.gradientColor,
    required this.textColor,
    required this.inverseTextColor,
    required this.active,
    required this.createdAt,
    required this.missionCount,
    required this.followerCount,
    required this.followers,
    required this.isFollowing,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? "",
      name: json['name'] ?? '',
      about: json['about'] ?? "",
      logo: json['logo'] ?? "",
      logoBgColor: json['logo_bg_color'] ?? '#FFFFFF',
      gradientColor: MissionGradient.fromJson(json['gradient_color'] ?? {}),
      textColor: json['text_color'] ?? '#FFFFFF',
      inverseTextColor: json['inverse_text_color'] ?? '#000000',
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      missionCount: json['mission_count'] ?? 0,
      followerCount: json['follower_count'] ?? 0,
      followers: (json['followers'] as List<dynamic>? ?? [])
          .map((e) => Users.fromJson(e))
          .toList(),
      isFollowing: json['is_following'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['about'] = about;
    data['logo'] = logo;
    data['logo_bg_color'] = logoBgColor;
    data['gradient_color'] = gradientColor;
    data['text_color'] = textColor;
    data['inverse_text_color'] = inverseTextColor;
    data['active'] = active;
    data['created_at'] = createdAt;
    data['mission_count'] = missionCount;
    data['follower_count'] = followerCount;
    data['followers'] = followers.map((e) => e.toJson()).toList();
    data['is_following'] = isFollowing;
    return data;
  }
}
