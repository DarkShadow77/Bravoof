import 'community_mission_model.dart';

class SocialMission {
  final int id;
  final String title;
  final String image;
  final String instructionTitle;
  final List<MissionInstruction> instructions;
  final DateTime createdAt;
  final int points;

  SocialMission({
    required this.id,
    required this.title,
    required this.image,
    required this.instructionTitle,
    required this.instructions,
    required this.createdAt,
    required this.points,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': image,
      'points': points,
      'instruction_title': instructionTitle,
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
