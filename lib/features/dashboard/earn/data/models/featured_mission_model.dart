import 'community_mission_model.dart';

class FeaturedMission {
  final int id;
  final String by;
  final String title;
  final String subtitle;
  final String color; // HEX string
  final String textColor; // HEX string
  final String image;
  final int points;
  final String instructionTitle;
  final DateTime createdAt;
  final List<MissionInstruction> instructions;

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
  });

  factory FeaturedMission.fromJson(Map<String, dynamic> json) {
    return FeaturedMission(
      id: json['id'],
      by: json['by'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: json['color'] ?? '#000000',
      textColor: json['text_color'] ?? '#ffffff',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      instructionTitle: json['instruction_title'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
    );
  }
}
