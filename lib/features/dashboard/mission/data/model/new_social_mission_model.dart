import 'community_mission_model.dart';
import 'featured_mission_model.dart';

class NewSocialMission {
  final int id;
  final String title;
  final String subtitle;
  final MissionGradient color; // HEX string
  final String textColor;
  final String inverseTextColor;
  final String image;
  final int points;
  final String instructionTitle;
  final String submissionType;
  final DateTime createdAt;
  final List<MissionInstruction> instructions;

  NewSocialMission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.inverseTextColor,
    required this.image,
    required this.points,
    required this.instructionTitle,
    required this.submissionType,
    required this.createdAt,
    required this.instructions,
  });

  factory NewSocialMission.fromJson(Map<String, dynamic> json) {
    return NewSocialMission(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: MissionGradient.fromJson(json['color']),
      textColor: json['text_color'] ?? '#ffffff',
      inverseTextColor: json['inverse_text_color'] ?? '#000000',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      instructionTitle: json['instruction_title'] ?? '',
      submissionType: json['submission_type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
    );
  }
}
