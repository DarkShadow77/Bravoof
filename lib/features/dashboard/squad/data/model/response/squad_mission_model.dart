import '../../../../mission/data/model/community_mission_model.dart';
import '../../../../mission/data/model/mission_status_enum.dart';

class SquadMission {
  final int id;
  final String squadId;
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

  SquadMission({
    required this.id,
    required this.squadId,
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

  factory SquadMission.fromJson(Map<String, dynamic> json) {
    DateTime? endsAt;
    if (json['ends_at'] != null) {
      endsAt = DateTime.tryParse(json['ends_at']);
    }

    return SquadMission(
      id: json['id'] ?? 0,
      squadId: json['squad_id'] ?? "",
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
}

class JoinedSquadMission {
  final int chatRoomId;
  final bool isCaptain;

  JoinedSquadMission({required this.chatRoomId, this.isCaptain = false});

  factory JoinedSquadMission.fromJson(Map<String, dynamic> json) {
    return JoinedSquadMission(
      chatRoomId: json['chat_room_id'],
      isCaptain: json['is_captain'] ?? false,
    );
  }
}

extension SquadMissionX on SquadMission {
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

String getTimeLeft(DateTime? endsAt) {
  if (endsAt == null) return "∞";

  final now = DateTime.now();

  if (now.isAfter(endsAt)) return "Ended";

  final difference = endsAt.difference(now);

  if (difference.inDays >= 1) {
    return "${difference.inDays} Day${difference.inDays == 1 ? '' : 's'} left";
  } else if (difference.inHours >= 1) {
    return "${difference.inHours} Hour${difference.inHours == 1 ? '' : 's'} left";
  } else {
    final minutes = difference.inMinutes;
    return "${minutes <= 0 ? 1 : minutes} Minute${minutes == 1 ? '' : 's'} left";
  }
}
