import 'package:collection/collection.dart';

import '../../../../mission/data/model/featured_mission_model.dart';
import '../../../../profile/data/model/users_model.dart';

enum ActivityType {
  followBrand,
  joinSquad,
  startSquadMission,
  startBrandMission,
  unknown,
}

class RecentActivity {
  final int id;
  final ActivityType activityType;
  final String message;
  final DateTime createdAt;
  final Users user;

  // Only set for relevant activity types
  final ActivitySquad? squad;
  final ActivityBrand? brand;
  final ActivityMission? squadMission;
  final ActivityMission? brandMission;

  final List<Users> missionParticipants;
  final ActivityReactions reactions;

  RecentActivity({
    required this.id,
    required this.activityType,
    required this.message,
    required this.createdAt,
    required this.user,
    this.squad,
    this.brand,
    this.squadMission,
    this.brandMission,
    required this.missionParticipants,
    required this.reactions,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      activityType: _parseActivityType(json['activity_type']),
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      user: Users.fromJson(json['user'] ?? {}),
      squad: json['squad'] != null
          ? ActivitySquad.fromJson(json['squad'])
          : null,
      brand: json['brand'] != null
          ? ActivityBrand.fromJson(json['brand'])
          : null,
      squadMission: json['squad_mission'] != null
          ? ActivityMission.fromJson(json['squad_mission'])
          : null,
      brandMission: json['brand_mission'] != null
          ? ActivityMission.fromJson(json['brand_mission'])
          : null,
      missionParticipants:
          (json['mission_participants'] as List<dynamic>? ?? [])
              .map((e) => Users.fromJson(e))
              .toList(),
      reactions: ActivityReactions.fromJson(
        json['reactions'] as Map<String, dynamic>? ?? {},
        json['user_reactions'] as List<dynamic>? ?? [],
      ),
    );
  }

  static ActivityType _parseActivityType(String? type) {
    switch (type) {
      case 'follow_brand':
        return ActivityType.followBrand;
      case 'join_squad':
        return ActivityType.joinSquad;
      case 'start_squad_mission':
        return ActivityType.startSquadMission;
      case 'start_brand_mission':
        return ActivityType.startBrandMission;
      default:
        return ActivityType.unknown;
    }
  }
}

// Paginated response wrapper for the activity feed
class RecentActivityPage {
  final List<RecentActivity> activities;
  final int page;
  final bool hasMore;

  RecentActivityPage({
    required this.activities,
    required this.page,
    required this.hasMore,
  });

  factory RecentActivityPage.fromJson(Map<String, dynamic> json) {
    return RecentActivityPage(
      activities: (json['activities'] as List<dynamic>? ?? [])
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      hasMore: json['has_more'] ?? false,
    );
  }
}

class ActivitySquad {
  final String id;
  final String name;
  final String image;
  final MissionGradient gradientColor;
  final String textColor;

  ActivitySquad({
    required this.id,
    required this.name,
    required this.image,
    required this.gradientColor,
    required this.textColor,
  });

  factory ActivitySquad.fromJson(Map<String, dynamic> json) {
    return ActivitySquad(
      id: json['id'] ?? "",
      name: json['name'] ?? '',
      image: json['image'] ?? "",
      gradientColor: MissionGradient.fromJson(json['gradient_color'] ?? {}),
      textColor: json['text_color'] ?? '#000000',
    );
  }
}

class ActivityBrand {
  final String id;
  final String name;
  final String logo;
  final String logoBgColor;
  final MissionGradient gradientColor;
  final String textColor;

  ActivityBrand({
    required this.id,
    required this.name,
    required this.logo,
    required this.logoBgColor,
    required this.gradientColor,
    required this.textColor,
  });

  factory ActivityBrand.fromJson(Map<String, dynamic> json) {
    return ActivityBrand(
      id: json['id'] ?? "",
      name: json['name'] ?? '',
      logo: json['logo'] ?? "",
      logoBgColor: json['logo_bg_color'] ?? '#FFFFFF',
      gradientColor: MissionGradient.fromJson(json['gradient_color'] ?? {}),
      textColor: json['text_color'] ?? '#FFFFFF',
    );
  }
}

class ActivityMission {
  final int id;
  final String title;

  ActivityMission({required this.id, required this.title});

  factory ActivityMission.fromJson(Map<String, dynamic> json) {
    return ActivityMission(id: json['id'] ?? 0, title: json['title'] ?? '');
  }
}

enum ReactionEmoji {
  heart('❤️'),
  fire('🔥'),
  clap('👏'),
  wow('😮'),
  party('🎉'),
  hundred('💯');

  const ReactionEmoji(this.emoji);
  final String emoji;

  /// From emoji string → enum
  static ReactionEmoji? fromEmoji(String emoji) {
    return ReactionEmoji.values.firstWhereOrNull((e) => e.emoji == emoji);
  }
}

class ActivityReactions {
  final int heart;
  final int fire;
  final int clap;
  final int wow;
  final int party;
  final int hundred;

  // Which emojis the current user has reacted with
  final List<ReactionEmoji> userReactions;

  ActivityReactions({
    required this.heart,
    required this.fire,
    required this.clap,
    required this.wow,
    required this.party,
    required this.hundred,
    required this.userReactions,
  });

  factory ActivityReactions.fromJson(
    Map<String, dynamic> counts,
    List<dynamic> userReactions,
  ) {
    return ActivityReactions(
      heart: counts['❤️'] ?? 0,
      fire: counts['🔥'] ?? 0,
      clap: counts['👏'] ?? 0,
      wow: counts['😮'] ?? 0,
      party: counts['🎉'] ?? 0,
      hundred: counts['💯'] ?? 0,
      userReactions: userReactions
          .map((e) => ReactionEmoji.fromEmoji(e.toString()))
          .whereType<ReactionEmoji>()
          .toList(),
    );
  }

  bool hasReacted(ReactionEmoji reaction) => userReactions.contains(reaction);

  int countFor(ReactionEmoji reaction) {
    switch (reaction) {
      case ReactionEmoji.heart:
        return heart;
      case ReactionEmoji.fire:
        return fire;
      case ReactionEmoji.clap:
        return clap;
      case ReactionEmoji.wow:
        return wow;
      case ReactionEmoji.party:
        return party;
      case ReactionEmoji.hundred:
        return hundred;
    }
  }
}

class ActivityReactionResult {
  final int activityId;
  final ActivityReactions reactions;
  final List<String> userReactions;

  ActivityReactionResult({
    required this.activityId,
    required this.reactions,
    required this.userReactions,
  });

  factory ActivityReactionResult.fromJson(Map<String, dynamic> json) {
    return ActivityReactionResult(
      activityId: json['activity_id'] ?? 0,
      reactions: ActivityReactions.fromJson(
        json['reactions'] as Map<String, dynamic>? ?? {},
        json['user_reactions'] as List<dynamic>? ?? [],
      ),
      userReactions: (json['user_reactions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
