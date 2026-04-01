import 'package:bravoo/features/dashboard/mission/data/model/community_mission_model.dart';

import '../../../../mission/data/model/mission_status_enum.dart';

class BrandMission {
  final int id;
  final String brandId;
  final String title;
  final String subtitle;
  final String instructionTitle;
  final List<MissionInstruction> instructions;
  final int points;
  final String submissionType;
  final int maxUsers;
  final int usersJoined;
  final bool active;
  final DateTime createdAt;
  final MissionStatus userStatus;

  BrandMission({
    required this.id,
    required this.brandId,
    required this.title,
    required this.subtitle,
    required this.instructionTitle,
    required this.instructions,
    required this.points,
    required this.submissionType,
    required this.maxUsers,
    required this.usersJoined,
    required this.active,
    required this.createdAt,
    required this.userStatus,
  });

  factory BrandMission.fromJson(Map<String, dynamic> json) {
    return BrandMission(
      id: json['id'] ?? 0,
      brandId: json['brand_id'] ?? "",
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? "",
      instructionTitle: json['instruction_title'] ?? "Mission Instructions",
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
      points: json['points'] ?? 0,
      submissionType: json['submission_type'] ?? 'photo',
      maxUsers: json['max_users'] ?? 0,
      usersJoined: json['users_joined'] ?? 0,
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      userStatus: statusFromDb(json['user_status'] ?? ''),
    );
  }
}
