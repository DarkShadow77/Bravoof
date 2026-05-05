class ChatMessageSender {
  final String userId;
  final String? name;
  final String? profileImage;

  ChatMessageSender({required this.userId, this.name, this.profileImage});

  factory ChatMessageSender.fromJson(Map<String, dynamic> json) {
    return ChatMessageSender(
      userId: json['user_id'] ?? '',
      name: json['name'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'profile_image': profileImage,
  };
}

class ChatMessageReply {
  final int id;
  final String? content;
  final String? mediaUrl;
  final String? mediaType;
  final String userId;
  final ChatMessageSender? sender;

  ChatMessageReply({
    required this.id,
    this.content,
    this.mediaUrl,
    this.mediaType,
    required this.userId,
    this.sender,
  });

  factory ChatMessageReply.fromJson(Map<String, dynamic> json) {
    final rawSender = ChatMessage._unwrap(json['user_profile']);
    return ChatMessageReply(
      id: json['id'],
      content: json['content'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      userId: json['user_id'] ?? '',
      sender: rawSender != null ? ChatMessageSender.fromJson(rawSender) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'user_id': userId,
      'user_profile': sender?.toJson(),
    };
  }
}

enum MessageStatus { sent, pending, failed }

class ChatMessage {
  final int id;
  final int chatRoomId;
  final String userId;
  final bool isSystem;
  final String? content;
  final String? mediaUrl;
  final String? mediaType; // 'image' | 'video'
  final int? replyToId;
  final DateTime createdAt;
  final ChatMessageSender? sender;
  final ChatMessageReply? replyTo;
  final MessageStatus status;
  final String? localId;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.isSystem,
    this.content,
    this.mediaUrl,
    this.mediaType,
    this.replyToId,
    required this.createdAt,
    this.sender,
    this.replyTo,
    this.status = MessageStatus.sent,
    this.localId,
  });

  bool get isMedia => mediaUrl != null;
  bool get isImage => mediaType == 'image';
  bool get isVideo => mediaType == 'video';
  bool get isPending => status == MessageStatus.pending;
  bool get isFailed => status == MessageStatus.failed;

  ChatMessage copyWith({
    int? id,
    MessageStatus? status,
    String? mediaUrl,
    String? mediaType,
    String? localId,
    ChatMessageReply? replyTo,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId,
      userId: userId,
      isSystem: isSystem,
      content: content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      replyToId: replyToId,
      createdAt: createdAt,
      sender: sender,
      replyTo: replyTo ?? this.replyTo,
      status: status ?? this.status,
      localId: localId ?? this.localId,
    );
  }

  static dynamic _unwrap(dynamic val) {
    if (val == null) return null;
    if (val is List) return val.isEmpty ? null : val.first;
    return val;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawSender = _unwrap(json['user_profile']);
    final rawReply = _unwrap(json['reply_to']);

    return ChatMessage(
      id: json['id'],
      chatRoomId: json['chat_room_id'],
      userId: json['user_id'] ?? '',
      isSystem: json['is_system'] ?? false,
      content: json['content'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      replyToId: json['reply_to_id'],
      createdAt: DateTime.parse(json['created_at']),
      sender: rawSender != null ? ChatMessageSender.fromJson(rawSender) : null,
      replyTo: rawReply != null ? ChatMessageReply.fromJson(rawReply) : null,
      status: MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'chat_room_id': chatRoomId,
    'user_id': userId,
    'is_system': isSystem,
    'content': content,
    'media_url': mediaUrl,
    'media_type': mediaType,
    'reply_to_id': replyToId,
    'created_at': createdAt.toIso8601String(),
    'user_profile': sender?.toJson(),
    'reply_to': replyTo?.toJson(),
    // Never persist pending/failed messages
    'status': status == MessageStatus.sent ? 'sent' : null,
    'local_id': localId,
  };
}

class MissionChatMembers {
  final List<MissionChatMember> members;
  final String captainId;
  final bool isCurrentUserCaptain;

  MissionChatMembers({
    required this.members,
    required this.captainId,
    required this.isCurrentUserCaptain,
  });

  factory MissionChatMembers.fromJson(Map<String, dynamic> json) {
    return MissionChatMembers(
      members: (json['members'] as List<dynamic>? ?? [])
          .map((e) => MissionChatMember.fromJson(e))
          .toList(),
      captainId: json['captain_id'] ?? "",
      isCurrentUserCaptain: json['is_current_user_captain'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'members': members.map((m) => m.toJson()).toList(),
    'captain_id': captainId,
    'is_current_user_captain': isCurrentUserCaptain,
  };
}

class MissionChatMember {
  final String userId;
  final String? name;
  final String? profileImage;
  final DateTime joinedAt;
  final bool isCaptain;

  MissionChatMember({
    required this.userId,
    this.name,
    this.profileImage,
    required this.joinedAt,
    required this.isCaptain,
  });

  factory MissionChatMember.fromJson(Map<String, dynamic> json) {
    return MissionChatMember(
      userId: json['user_id'] ?? '',
      name: json['name'],
      profileImage: json['profile_image'],
      joinedAt: DateTime.parse(json['joined_at']),
      isCaptain: json['is_captain'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'profile_image': profileImage,
    'joined_at': joinedAt.toIso8601String(),
    'is_captain': isCaptain,
  };
}

class MissionChatRoom {
  final int id;
  final int squadMissionId;
  final DateTime? createdAt;

  MissionChatRoom({
    required this.id,
    required this.squadMissionId,
    this.createdAt,
  });

  factory MissionChatRoom.fromJson(Map<String, dynamic> json) {
    return MissionChatRoom(
      id: json['id'],
      squadMissionId: json['squad_mission_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'squad_mission_id': squadMissionId,
    'created_at': createdAt?.toIso8601String(),
  };
}

class MissionChatResponse {
  final MissionChatRoom? chatRoom;
  final List<ChatMessage> messages;
  final bool hasMore;
  final String? captainId;
  final bool isCurrentUserCaptain;

  MissionChatResponse({
    this.chatRoom,
    required this.messages,
    required this.hasMore,
    this.captainId,
    required this.isCurrentUserCaptain,
  });

  MissionChatResponse copyWith({List<ChatMessage>? messages, bool? hasMore}) {
    return MissionChatResponse(
      chatRoom: chatRoom,
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      captainId: captainId,
      isCurrentUserCaptain: isCurrentUserCaptain,
    );
  }

  factory MissionChatResponse.fromJson(Map<String, dynamic> json) {
    return MissionChatResponse(
      chatRoom: json['chat_room'] != null
          ? MissionChatRoom.fromJson(json['chat_room'])
          : null,
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
      hasMore: json['has_more'] ?? false,
      captainId: json['captain_id'],
      isCurrentUserCaptain: json['is_current_user_captain'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'chat_room': chatRoom?.toJson(),
    'messages': messages
        .where((m) => m.status == MessageStatus.sent) // drop optimistic/failed
        .map((m) => m.toJson())
        .toList(),
    'has_more': hasMore,
    'captain_id': captainId,
    'is_current_user_captain': isCurrentUserCaptain,
  };
}
