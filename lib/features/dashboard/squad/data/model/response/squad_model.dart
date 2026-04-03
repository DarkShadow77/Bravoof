import '../../../../mission/data/model/featured_mission_model.dart';
import '../../../../profile/data/model/users_model.dart';

class Squad {
  final String id;
  final String name;
  final String about;
  final String image;
  final MissionGradient gradientColor;
  final String textColor;
  final int maxUsers;
  final int usersJoined;
  final bool active;
  final DateTime createdAt;
  final bool isJoined;
  final bool isFull;
  final bool canJoin;
  final int cooldownDaysRemaining;
  final List<Users> members;

  Squad({
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.gradientColor,
    required this.textColor,
    required this.maxUsers,
    required this.usersJoined,
    required this.active,
    required this.createdAt,
    required this.isJoined,
    required this.isFull,
    required this.canJoin,
    required this.cooldownDaysRemaining,
    required this.members,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id'] ?? "",
      name: json['name'] ?? '',
      about: json['about'] ?? "",
      image: json['image'] ?? "",
      gradientColor: MissionGradient.fromJson(json['gradient_color'] ?? {}),
      textColor: json['text_color'] ?? '#FFFFFF',
      maxUsers: json['max_users'] ?? 0,
      usersJoined: json['users_joined'] ?? 0,
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      isJoined: json['is_joined'] ?? false,
      isFull: json['is_full'] ?? false,
      canJoin: json['can_join'] ?? false,
      cooldownDaysRemaining: json['cooldown_days_remaining'] ?? 0,
      members: (json['members'] as List<dynamic>? ?? [])
          .map((e) => Users.fromJson(e))
          .toList(),
    );
  }
}

class UserSquad {
  final String id;
  final String name;
  final String about;
  final String image;
  final MissionGradient gradientColor;
  final String textColor;

  UserSquad({
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.gradientColor,
    required this.textColor,
  });

  factory UserSquad.fromJson(Map<String, dynamic> json) {
    return UserSquad(
      id: json['id'] ?? "",
      name: json['name'] ?? '',
      about: json['about'] ?? "",
      image: json['image'] ?? "",
      gradientColor: MissionGradient.fromJson(json['gradient_color'] ?? {}),
      textColor: json['text_color'] ?? '#FFFFFF',
    );
  }
}
