import '../../../../mission/data/model/community_mission_model.dart';
import '../../../../mission/data/model/mission_status_enum.dart';

class SquadMission {
  final int id;
  final String squadId;
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

  SquadMission({
    required this.id,
    required this.squadId,
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

  factory SquadMission.fromJson(Map<String, dynamic> json) {
    return SquadMission(
      id: json['id'] ?? 0,
      squadId: json['squad_id'] ?? "",
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
