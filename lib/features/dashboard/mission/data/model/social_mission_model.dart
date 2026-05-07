import 'community_mission_model.dart';
import 'mission_status_enum.dart';

class SocialMission {
  final int id;
  final String title;
  final String image;
  final String instructionTitle;
  final List<MissionInstruction> instructions;
  final DateTime createdAt;
  final int points;
  final String submissionType;
  final bool hasJoined;
  final MissionStatus? userStatus;

  SocialMission({
    required this.id,
    required this.title,
    required this.image,
    required this.instructionTitle,
    required this.instructions,
    required this.createdAt,
    required this.points,
    required this.submissionType,
    this.hasJoined = false,
    this.userStatus,
  });

  factory SocialMission.fromJson(Map<String, dynamic> json) {
    return SocialMission(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image_url'] ?? '',
      instructionTitle: json['instruction_title'] ?? '',
      instructions: (json['instructions'] as List? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      points: json['points'] ?? 0,
      submissionType: json['submission_type'] ?? '',
      hasJoined: json['has_joined'] ?? false,
      userStatus: json['user_status'] != null
          ? statusFromDb(json['user_status'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': image,
      'points': points,
      'instruction_title': instructionTitle,
      'submission_type': submissionType,
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
