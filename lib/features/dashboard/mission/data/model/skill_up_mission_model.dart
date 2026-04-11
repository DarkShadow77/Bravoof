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
  final String submissionType;

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
    required this.submissionType,
  });

  factory SkillUpStep.fromJson(Map<String, dynamic> json) {
    // Filter to only this user's unlock/progress records
    final unlockList = json['skill_up_step_unlocks'] as List?;
    final progressList = json['skill_up_user_progress'] as List?;

    // Take the first (should only ever be one per user after filtering)
    final unlock = unlockList?.firstOrNull;
    final progress = progressList?.firstOrNull;

    // Unlock is valid only if expires_at is in the future
    final unlockExpiresAt = unlock != null
        ? DateTime.tryParse(unlock['expires_at'] ?? '')
        : null;

    final status = progress == null
        ? MissionStatus.notJoined
        : statusFromDb((progress['status'] ?? "") as String);

    SkillUpContentBlock? parseContent(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>)
        return SkillUpContentBlock.fromJson(value);
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
      unlockExpiresAt: unlockExpiresAt,
      /*unlockSource: unlock != null
          ? UnlockSource.fromDb(unlock['unlock_source'])
          : null,*/
      status: status,
      submissionType: json['submission_type'] ?? 'photo',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'step_order': stepOrder,
    'title': title,
    'subject': subject,
    'min_points': minPoints,
    'max_points': maxPoints,
    'content_one': contentOne?.toJson(),
    'content_two': contentTwo?.toJson(),
    'locked': locked,
    'unlock_expires_at': unlockExpiresAt?.toIso8601String(),
    'status': statusToDb(status),
    'submission_type': submissionType,
  };

  bool get isPhotoSubmission => submissionType == 'photo';
  bool get isTextSubmission => submissionType == 'text';
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

  bool get isPending => status == MissionStatus.pending;
  bool get isApproved => status == MissionStatus.completed;
  bool get isRejected => status == MissionStatus.rejected;
  bool get isNotJoined => status == MissionStatus.notJoined;

  /// User can start/restart the mission
  bool get canStart => isNotJoined || isRejected;
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

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'content': content,
    if (link != null) 'link': link!.toJson(),
  };
}

class ContentLink {
  final String url;
  final String type;

  ContentLink({required this.url, required this.type});

  factory ContentLink.fromJson(Map<String, dynamic> json) {
    return ContentLink(url: json['url'] ?? '', type: json['type'] ?? '');
  }

  Map<String, dynamic> toJson() => {'url': url, 'type': type};
}
