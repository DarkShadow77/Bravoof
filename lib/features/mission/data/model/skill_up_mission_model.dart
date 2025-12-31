import 'dart:convert';

import 'featured_mission_model.dart';
import 'mission_status_enum.dart';

enum UnlockSource { coins, video }

class SkillUpMission {
  final int id;
  final String title;
  final String image;
  final bool isHot;
  final MissionGradient color;
  final List<SkillUpStep> steps;

  SkillUpMission({
    required this.id,
    required this.title,
    required this.image,
    required this.isHot,
    required this.color,
    required this.steps,
  });

  factory SkillUpMission.fromJson(Map<String, dynamic> json) {
    return SkillUpMission(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      isHot: json['is_hot'] ?? false,
      color: MissionGradient.fromJson(json['color']),
      steps: (json['skill_up_steps'] as List<dynamic>? ?? [])
          .map((e) => SkillUpStep.fromJson(e))
          .toList(),
    );
  }
}

class SkillUpStep {
  final int id;
  final int stepOrder;
  final String title;
  final String subject;
  final int minPoints;
  final int maxPoints;
  final SkillUpContentBlock? contentOne;
  final SkillUpContentBlock? contentTwo;
  final bool locked;
  final DateTime? unlockExpiresAt;
  // final UnlockSource? unlockSource;
  final MissionStatus status;

  SkillUpStep({
    required this.id,
    required this.stepOrder,
    required this.title,
    required this.subject,
    required this.minPoints,
    required this.maxPoints,
    this.contentOne,
    this.contentTwo,
    required this.locked,
    required this.status,
    this.unlockExpiresAt,
    // this.unlockSource,
  });

  factory SkillUpStep.fromJson(Map<String, dynamic> json) {
    final unlock = (json['skill_up_step_unlocks'] as List?)?.firstOrNull;
    final progress = (json['skill_up_user_progress'] as List?)?.firstOrNull;

    final isUnlocked =
        unlock != null &&
        DateTime.parse(unlock['expires_at']).isAfter(DateTime.now());

    final status = progress == null
        ? MissionStatus.notJoined
        : statusFromDb(progress['status']);

    SkillUpContentBlock? parseContent(dynamic value) {
      if (value == null) return null;

      // Supabase returns JSONB as Map, not String
      if (value is Map<String, dynamic>) {
        return SkillUpContentBlock.fromJson(value);
      }

      // Fallback if stored as string
      if (value is String) {
        return SkillUpContentBlock.fromJson(
          Map<String, dynamic>.from(jsonDecode(value)),
        );
      }

      return null;
    }

    return SkillUpStep(
      id: json['id'],
      stepOrder: json['step_order'] ?? 0,
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      minPoints: json['min_points'] ?? 0,
      maxPoints: json['max_points'] ?? 0,
      contentOne: parseContent(json['content_one']),
      contentTwo: parseContent(json['content_two']),
      locked: json['locked'] ?? false,
      unlockExpiresAt: unlock != null
          ? DateTime.parse(unlock['expires_at'])
          : null,

      /*unlockSource: unlock != null
          ? UnlockSource.fromDb(unlock['unlock_source'])
          : null,*/
      status: status,
    );
  }
}

extension SkillUpStepX on SkillUpStep {
  /// Is this step currently unlocked for the user?
  bool get isUnlocked {
    if (!locked) return true;

    if (unlockExpiresAt == null) return false;

    return unlockExpiresAt!.isAfter(DateTime.now());
  }

  /// Remaining unlock time (null if not unlocked)
  Duration? get unlockTimeLeft {
    if (!isUnlocked || unlockExpiresAt == null) return null;

    return unlockExpiresAt!.difference(DateTime.now());
  }

  /// Should show "Unlock Mission" button
  bool get needsUnlock => locked && !isUnlocked;
}

class SkillUpContentBlock {
  final String title;
  final String subtitle;
  final String content;
  final ContentLink? link;

  SkillUpContentBlock({
    required this.title,
    required this.subtitle,
    required this.content,
    this.link,
  });

  factory SkillUpContentBlock.fromJson(Map<String, dynamic> json) {
    return SkillUpContentBlock(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      content: json['content'] ?? '',
      link: json['link'] != null ? ContentLink.fromJson(json['link']) : null,
    );
  }
}

class ContentLink {
  final String url;
  final String type;

  ContentLink({required this.url, required this.type});

  factory ContentLink.fromJson(Map<String, dynamic> json) {
    return ContentLink(url: json['url'] ?? '', type: json['type'] ?? '');
  }
}
