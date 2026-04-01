import 'community_mission_model.dart';

class FeaturedMission {
  final int id;
  final String by;
  final String title;
  final String subtitle;
  final MissionGradient color; // HEX string
  final String textColor; // HEX string
  final String image;
  final int points;
  final String instructionTitle;
  final DateTime createdAt;
  final List<MissionInstruction> instructions;
  final String submissionType;
  final int maxUsers;
  final int usersJoined;

  FeaturedMission({
    required this.id,
    required this.by,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.image,
    required this.points,
    required this.instructionTitle,
    required this.createdAt,
    required this.instructions,
    required this.submissionType,
    required this.maxUsers,
    required this.usersJoined,
  });

  factory FeaturedMission.fromJson(Map<String, dynamic> json) {
    return FeaturedMission(
      id: json['id'],
      by: json['by'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: MissionGradient.fromJson(json['color'] ?? {}),
      textColor: json['text_color'] ?? '#ffffff',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      instructionTitle: json['instruction_title'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
      submissionType: json['submission_type'] ?? '',
      maxUsers: json['max_users'] ?? 0,
      usersJoined: json['users_joined'] ?? 0,
    );
  }
}

class MissionGradient {
  final String start;
  final String end;

  const MissionGradient({required this.start, required this.end});

  factory MissionGradient.fallback() {
    return const MissionGradient(start: '#000000', end: '#000000');
  }

  factory MissionGradient.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return MissionGradient.fallback();
    }

    return MissionGradient(
      start: json['start'] ?? '#000000',
      end: json['end'] ?? '#000000',
    );
  }
}
