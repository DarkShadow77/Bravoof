import 'community_mission_model.dart';
import 'featured_mission_model.dart';

class SponsoredMission {
  final int id;
  final String by;
  final String title;
  final String subtitle;
  final MissionGradient color;
  final String textColor; // HEX string
  final String image;
  final int points;
  final String instructionTitle;
  final DateTime createdAt;
  final List<MissionInstruction> instructions;

  SponsoredMission({
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

  factory SponsoredMission.fromJson(Map<String, dynamic> json) {
    return SponsoredMission(
      id: json['id'],
      by: json['by'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: MissionGradient.fromJson(json['color']),
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
