import 'package:bravoo/features/dashboard/mission/data/model/community_mission_model.dart';

import '../../../../mission/data/model/mission_status_enum.dart';
import 'squad_mission_model.dart';

class BrandMission {
  final int id;
  final String brandId;
  final String title;
  final String subtitle;
  final String image;
  final String about;
  final String hashtags;
  final String instructionTitle;
  final List<MissionInstruction> instructions;
  final int points;
  final String submissionType;
  final int maxUsers;
  final int usersJoined;
  final bool active;
  final DateTime createdAt;
  final DateTime? endsAt;
  final MissionStatus userStatus;
  final bool isJoined;
  final bool isFull;
  final bool hasExpired;
  final bool canJoin;
  final int? chatRoomId;

  BrandMission({
    required this.id,
    required this.brandId,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.about,
    required this.hashtags,
    required this.instructionTitle,
    required this.instructions,
    required this.points,
    required this.submissionType,
    required this.maxUsers,
    required this.usersJoined,
    required this.active,
    required this.createdAt,
    this.endsAt,
    required this.userStatus,
    this.isJoined = false,
    this.isFull = false,
    this.hasExpired = false,
    this.canJoin = false,
    this.chatRoomId,
  });

  factory BrandMission.fromJson(Map<String, dynamic> json) {
    DateTime? endsAt;
    if (json['ends_at'] != null) {
      endsAt = DateTime.tryParse(json['ends_at']);
    }

    return BrandMission(
      id: json['id'] ?? 0,
      brandId: json['brand_id'] ?? "",
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? "",
      image: json['image'] ?? "",
      about: json['about'] ?? "",
      hashtags: json['hashtags'] ?? "",
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
      endsAt: endsAt,
      userStatus: statusFromDb(json['user_status'] ?? ''),
      isJoined: json['is_joined'] ?? false,
      isFull: json['is_full'] ?? false,
      hasExpired: json['has_expired'] ?? false,
      canJoin: json['can_join'] ?? false,
      chatRoomId: json['chat_room_id'] as int?,
    );
  }

  bool get isPhotoSubmission => submissionType == 'photo';
  bool get isTextSubmission => submissionType == 'text';
}

class JoinedBrandMission {
  final int chatRoomId;
  final bool isCaptain;

  JoinedBrandMission({required this.chatRoomId, this.isCaptain = false});

  factory JoinedBrandMission.fromJson(Map<String, dynamic> json) {
    return JoinedBrandMission(
      chatRoomId: json['chat_room_id'],
      isCaptain: json['is_captain'] ?? false,
    );
  }
}

extension BrandMissionX on BrandMission {
  String get timeLeft => getTimeLeft(endsAt);

  /// Label for the primary action button on the mission card/detail page
  String get actionLabel {
    if (isJoined)
      return 'Chat';
    else if (hasExpired)
      return 'Expired';
    else if (isFull)
      return 'Full';
    return 'Join Mission';
  }

  bool get isActionable => canJoin || isJoined;
}
