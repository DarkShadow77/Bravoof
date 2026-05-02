import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import 'package:uuid/uuid.dart';

import '../../data/model/response/squad_mission_chat_model.dart';
import '../../data/model/response/squad_mission_model.dart';
import '../../data/repository/squad_repository.dart';

part 'squad_mission_event.dart';
part 'squad_mission_state.dart';

class SquadMissionBloc extends Bloc<SquadMissionEvent, SquadMissionState> {
  final SquadRepository repo;
  final String squadId;
  final int missionId;
  bool _isCurrentlyTrackedAsTyping = false;

  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();
  final _currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

  Timer? _typingTimer;

  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _membersChannel;
  RealtimeChannel? _typingChannel;

  SquadMissionBloc({
    required this.repo,
    required this.squadId,
    required this.missionId,
  }) : super(SquadMissionInitialState(missionMembers: [], chatResponse: null)) {
    on<JoinSquadMissionEvent>(_joinMissions);
    on<FetchSquadMissionMembersEvent>(_fetchMissionMembers);
    on<LeaveSquadMissionEvent>(_leaveMissions);
    on<FetchSquadMissionChatEvent>(_fetchMissionChat);
    on<FetchMoreSquadMissionChatEvent>(_fetchMoreMissionChat);
    on<SendSquadMissionMessageEvent>(_sendMissionChat);
    on<RetrySendSquadMissionMessageEvent>(_retrySendMissionChat);
    on<SubmitSquadMissionEvent>(_submitMission);
    on<UserTypingEvent>(_onUserTyping);
    // Internal events fired by Realtime — not dispatched by the UI
    on<_NewRealtimeMessageEvent>(_onNewRealtimeMessage);
    on<_MemberJoinedEvent>(_onMemberJoined);
    on<_MemberLeftEvent>(_onMemberLeft);
    on<_TypingPresenceChangedEvent>(_onTypingPresenceChanged);
  }

  void subscribeToChat(int chatRoomId) {
    _messagesChannel?.unsubscribe();

    _messagesChannel = _supabase
        .channel('mission_chat_$missionId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'squad_mission_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_room_id',
            value: chatRoomId,
          ),
          callback: (payload) {
            // payload.newRecord is the raw row — no joins
            // We enrich sender from the local members map
            final raw = Map<String, dynamic>.from(payload.newRecord);
            add(_NewRealtimeMessageEvent(raw: raw));
          },
        )
        .subscribe();
  }

  void subscribeToMembers() {
    _membersChannel?.unsubscribe();

    _membersChannel = _supabase
        .channel('mission_members_$missionId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'squad_mission_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'squad_mission_id',
            value: missionId,
          ),
          callback: (payload) {
            add(
              _MemberJoinedEvent(
                raw: Map<String, dynamic>.from(payload.newRecord),
              ),
            );
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'squad_mission_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'squad_mission_id',
            value: missionId,
          ),
          callback: (payload) {
            add(
              _MemberLeftEvent(userId: payload.oldRecord['user_id'] as String),
            );
          },
        )
        .subscribe();
  }

  void subscribeToTyping() {
    _typingChannel?.unsubscribe();

    _typingChannel = _supabase
        .channel('typing_$missionId')
        .onPresenceSync((payload) {
          // ✅ presenceState() returns List<SinglePresenceState>
          final state = _typingChannel?.presenceState() ?? [];
          add(_TypingPresenceChangedEvent(presenceState: state));
        })
        .onPresenceJoin((payload) {
          final state = _typingChannel?.presenceState() ?? [];
          add(_TypingPresenceChangedEvent(presenceState: state));
        })
        .onPresenceLeave((payload) {
          final state = _typingChannel?.presenceState() ?? [];
          add(_TypingPresenceChangedEvent(presenceState: state));
        })
        .subscribe((status, [error]) async {
          if (status == RealtimeSubscribeStatus.subscribed) {
            await _typingChannel?.track({'user_id': _currentUserId});
          }
        });
  }

  void unsubscribe() {
    _messagesChannel?.unsubscribe();
    _membersChannel?.unsubscribe();
    _typingChannel?.unsubscribe();
    _messagesChannel = null;
    _membersChannel = null;
    _typingChannel = null;
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _isCurrentlyTrackedAsTyping = false;
    unsubscribe();
    return super.close();
  }

  // ─── Internal realtime handlers ─────────────────────────────────────────

  void _onNewRealtimeMessage(
    _NewRealtimeMessageEvent event,
    Emitter<SquadMissionState> emit,
  ) {
    final raw = event.raw;
    final incomingUserId = raw['user_id'] as String?;

    // Find sender from the local members list — avoids an extra network call
    final senderMember = state.missionMembers.firstWhere(
      (m) => m.userId == incomingUserId,
      orElse: () => MissionChatMember(
        userId: incomingUserId ?? '',
        joinedAt: DateTime.now(),
        isCaptain: false,
      ),
    );

    final sender = incomingUserId != null
        ? ChatMessageSender(
            userId: incomingUserId,
            name: senderMember.name,
            profileImage: senderMember.profileImage,
          )
        : null;

    final message = ChatMessage(
      id: raw['id'] as int,
      chatRoomId: raw['chat_room_id'] as int,
      userId: incomingUserId ?? '',
      isSystem: raw['is_system'] as bool? ?? false,
      content: raw['content'] as String?,
      mediaUrl: raw['media_url'] as String?,
      mediaType: raw['media_type'] as String?,
      replyToId: raw['reply_to_id'] as int?,
      createdAt: DateTime.parse(raw['created_at'] as String),
      sender: sender,
      status: MessageStatus.sent,
    );

    final currentMessages = state.chatResponse?.messages ?? [];

    // Skip if we already have this message (sent by current user — optimistic)
    final alreadyExists = currentMessages.any(
      (m) => m.id == message.id && m.status == MessageStatus.sent,
    );
    if (alreadyExists) return;

    // Replace the matching optimistic message if one exists for this user
    // (identified by pending status + same content + same userId)
    List<ChatMessage> updated;
    final optimisticIndex = currentMessages.indexWhere(
      (m) =>
          m.userId == message.userId &&
          m.status == MessageStatus.pending &&
          m.content == message.content,
    );

    if (optimisticIndex != -1) {
      final optimistic = currentMessages[optimisticIndex];
      updated = List.from(currentMessages);
      updated[optimisticIndex] = message.copyWith(
        localId: optimistic.localId,
        replyTo: optimistic.replyTo,
      );
    } else {
      updated = [...currentMessages, message];
    }

    _emitWithMessages(emit, updated);
  }

  void _onMemberJoined(
    _MemberJoinedEvent event,
    Emitter<SquadMissionState> emit,
  ) {
    final raw = event.raw;
    final userId = raw['user_id'] as String?;
    if (userId == null) return;

    // Avoid duplicates
    if (state.missionMembers.any((m) => m.userId == userId)) return;

    final newMember = MissionChatMember(
      userId: userId,
      joinedAt:
          DateTime.tryParse(raw['joined_at'] as String? ?? '') ??
          DateTime.now(),
      isCaptain: false,
    );

    // Recalculate captain flag: first by joined_at
    final updated = [...state.missionMembers, newMember]
      ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    final withCaptain = updated.asMap().entries.map((e) {
      return MissionChatMember(
        userId: e.value.userId,
        name: e.value.name,
        profileImage: e.value.profileImage,
        joinedAt: e.value.joinedAt,
        isCaptain: e.key == 0,
      );
    }).toList();

    emit(state.copWith(missionMembers: withCaptain));
  }

  void _onMemberLeft(_MemberLeftEvent event, Emitter<SquadMissionState> emit) {
    final updated =
        state.missionMembers.where((m) => m.userId != event.userId).toList()
          ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    final withCaptain = updated.asMap().entries.map((e) {
      return MissionChatMember(
        userId: e.value.userId,
        name: e.value.name,
        profileImage: e.value.profileImage,
        joinedAt: e.value.joinedAt,
        isCaptain: e.key == 0,
      );
    }).toList();

    emit(state.copWith(missionMembers: withCaptain));
  }

  void _onTypingPresenceChanged(
    _TypingPresenceChangedEvent event,
    Emitter<SquadMissionState> emit,
  ) {
    final typingIds = <String>[];

    for (final singlePresence in event.presenceState) {
      // Each SinglePresenceState has a .presences list
      for (final presence in singlePresence.presences) {
        final payload = presence.payload; // Map<String, dynamic>
        final userId = payload['user_id'] as String?;
        final isTyping = payload['is_typing'] as bool? ?? false;

        if (userId != null && userId != _currentUserId && isTyping) {
          typingIds.add(userId);
        }
      }
    }

    emit(state.copWith(typingUserIds: typingIds));
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Replaces a message in the current list by its localId.
  List<ChatMessage> _replaceMessage(
    List<ChatMessage> messages,
    String localId,
    ChatMessage replacement,
  ) {
    return messages.map((m) => m.localId == localId ? replacement : m).toList();
  }

  /// Emits a new state with an updated chatResponse message list.
  void _emitWithMessages(
    Emitter<SquadMissionState> emit,
    List<ChatMessage> messages, {
    bool? hasMore,
  }) {
    final updated =
        state.chatResponse?.copyWith(messages: messages, hasMore: hasMore) ??
        MissionChatResponse(
          messages: messages,
          hasMore: hasMore ?? false,
          isCurrentUserCaptain: false,
        );
    emit(state.copWith(chatResponse: updated));
  }

  // ─── Event handlers ──────────────────────────────────────────────────────
  Future<void> _joinMissions(
    JoinSquadMissionEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.joinMission,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.joinSquadMission(
      missionId: missionId,
      squadId: squadId,
    );

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.joinMission,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (joinedSquadMission) => emit(
        JoinedSquadMissionState(
          joinedSquadMission: joinedSquadMission,
          missionId: missionId,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
    );
  }

  Future<void> _fetchMissionMembers(
    FetchSquadMissionMembersEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.fetchMissionMembers,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.fetchMissionMembers(
      missionId: missionId,
      squadId: squadId,
    );

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.fetchMissionMembers,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (members) {
        emit(state.copWith(missionMembers: members.members));

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.fetchMissionMembers,
            missionId: missionId,
            message: "Fetched Members Successfully",
            missionMembers: members.members,
            chatResponse: state.chatResponse,
          ),
        );

        // Start listening for member changes once we have the initial list
        subscribeToMembers();
      },
    );
  }

  Future<void> _leaveMissions(
    LeaveSquadMissionEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.leaveMission,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.leaveSquadMission(
      missionId: missionId,
      squadId: squadId,
    );

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.leaveMission,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (message) => emit(
        SquadMissionSuccessState(
          type: SquadMissionType.leaveMission,
          missionId: missionId,
          message: message,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
    );
  }

  Future<void> _fetchMissionChat(
    FetchSquadMissionChatEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.fetchChat,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.fetchChat(missionId: missionId, squadId: squadId);

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.fetchChat,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (chat) {
        emit(state.copWith(chatResponse: chat));

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.fetchChat,
            missionId: missionId,
            message: "Fetched Mission Chat Successfully",
            chatResponse: chat,
            missionMembers: state.missionMembers,
          ),
        );

        // Start listening for new messages once we have the chat room ID
        if (chat.chatRoom != null) {
          subscribeToChat(chat.chatRoom!.id);
          subscribeToTyping();
        }
      },
    );
  }

  Future<void> _fetchMoreMissionChat(
    FetchMoreSquadMissionChatEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.fetchMoreChat,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.fetchChat(
      missionId: missionId,
      squadId: squadId,
      before: event.before,
    );

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.fetchMoreChat,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (olderChat) {
        final existingMessages = state.chatResponse?.messages ?? [];

        final merged = [
          ...olderChat.messages, // older page goes first (top of chat)
          ...existingMessages,
        ];

        final updatedChat = (state.chatResponse ?? olderChat).copyWith(
          messages: merged,
          hasMore: olderChat.hasMore,
        );

        emit(state.copWith(chatResponse: updatedChat));

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.fetchMoreChat,
            missionId: missionId,
            message: "Fetched More Chat Successfully",
            chatResponse: updatedChat,
            missionMembers: state.missionMembers,
          ),
        );
      },
    );
  }

  Future<void> _sendMissionChat(
    SendSquadMissionMessageEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    final localId = _uuid.v4();

    final optimisticMessage = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch, // temp negative ID
      chatRoomId: event.chatRoomId,
      userId: event.currentUserId,
      isSystem: false,
      content: event.content,
      mediaUrl: event.media,
      mediaType: event.media != null
          ? (event.media!.endsWith('.mp4') ? 'video' : 'image')
          : null,
      replyToId: event.replyToId != null
          ? int.tryParse(event.replyToId!)
          : null,
      createdAt: DateTime.now(),
      sender: event.currentUserSender,
      replyTo: event.replyToMessage,
      status: MessageStatus.pending,
      localId: localId,
    );

    final messagesWithOptimistic = <ChatMessage>[
      ...(state.chatResponse?.messages ?? []),
      optimisticMessage,
    ];

    _emitWithMessages(emit, messagesWithOptimistic);

    final res = await repo.sendMissionChat(
      missionId: missionId,
      chatRoomId: event.chatRoomId,
      content: event.content,
      replyToId: event.replyToId,
      media: event.media,
    );

    res.fold(
      (err) {
        final failed = _replaceMessage(
          state.chatResponse?.messages ?? [],
          localId,
          optimisticMessage.copyWith(status: MessageStatus.failed),
        );
        _emitWithMessages(emit, failed);

        emit(
          SquadMissionErrorState(
            type: SquadMissionType.sendMissionChat,
            missionId: missionId,
            message: err,
            missionMembers: state.missionMembers,
            chatResponse: state.chatResponse,
          ),
        );
      },
      (sentMessage) {
        final confirmed = _replaceMessage(
          state.chatResponse?.messages ?? [],
          localId,
          sentMessage.copyWith(status: MessageStatus.sent, localId: localId),
        );
        _emitWithMessages(emit, confirmed);

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.sendMissionChat,
            missionId: missionId,
            message: "Sent Chat Successfully",
            chatResponse: state.chatResponse,
            missionMembers: state.missionMembers,
          ),
        );
      },
    );
  }

  Future<void> _retrySendMissionChat(
    RetrySendSquadMissionMessageEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    final messages = state.chatResponse?.messages ?? [];
    final failed = messages.firstWhere(
      (m) => m.localId == event.localId,
      orElse: () => throw StateError('Message not found'),
    );

    // Mark as pending again
    final pendingMessages = _replaceMessage(
      messages,
      event.localId,
      failed.copyWith(status: MessageStatus.pending),
    );
    _emitWithMessages(emit, pendingMessages);

    final res = await repo.sendMissionChat(
      missionId: missionId,
      chatRoomId: failed.chatRoomId,
      content: failed.content,
      replyToId: failed.replyToId?.toString(),
      media: failed.mediaUrl,
    );

    res.fold(
      (err) {
        final failedAgain = _replaceMessage(
          state.chatResponse?.messages ?? [],
          event.localId,
          failed.copyWith(status: MessageStatus.failed),
        );
        _emitWithMessages(emit, failedAgain);

        emit(
          SquadMissionErrorState(
            type: SquadMissionType.retrySendMissionChat,
            missionId: missionId,
            message: err,
            missionMembers: state.missionMembers,
            chatResponse: state.chatResponse,
          ),
        );
      },
      (sentMessage) {
        final confirmed = _replaceMessage(
          state.chatResponse?.messages ?? [],
          event.localId,
          sentMessage.copyWith(status: MessageStatus.sent),
        );
        _emitWithMessages(emit, confirmed);

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.retrySendMissionChat,
            missionId: missionId,
            message: "Message resent successfully",
            chatResponse: state.chatResponse,
            missionMembers: state.missionMembers,
          ),
        );
      },
    );
  }

  Future<void> _submitMission(
    SubmitSquadMissionEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    emit(
      SquadMissionLoadingState(
        type: SquadMissionType.submitMission,
        missionId: missionId,
        missionMembers: state.missionMembers,
        chatResponse: state.chatResponse,
      ),
    );

    final res = await repo.submitMission(
      missionId: missionId,
      squadId: squadId,
      image: event.image,
      text: event.text,
      isVideo: event.isVideo,
    );

    res.fold(
      (err) => emit(
        SquadMissionErrorState(
          type: SquadMissionType.submitMission,
          missionId: missionId,
          message: err,
          missionMembers: state.missionMembers,
          chatResponse: state.chatResponse,
        ),
      ),
      (message) => emit(
        SquadMissionSuccessState(
          type: SquadMissionType.submitMission,
          missionId: missionId,
          message: message,
          chatResponse: state.chatResponse,
          missionMembers: state.missionMembers,
        ),
      ),
    );
  }

  void _onUserTyping(
    UserTypingEvent event,
    Emitter<SquadMissionState> emit,
  ) async {
    if (event.isTyping) {
      // Cancel previous timer — extend the window on every keystroke
      _typingTimer?.cancel();

      // Only track if not already tracked as typing
      // to avoid flooding Supabase presence with updates
      if (!_isCurrentlyTrackedAsTyping) {
        _isCurrentlyTrackedAsTyping = true;
        await _typingChannel?.track({
          'user_id': _currentUserId,
          'is_typing': true,
        });
      }

      // Reset the auto-stop timer on every keystroke
      _typingTimer = Timer(const Duration(seconds: 2), () async {
        _isCurrentlyTrackedAsTyping = false;
        await _typingChannel?.track({
          'user_id': _currentUserId,
          'is_typing': false,
        });
      });
    } else {
      // Explicitly stopped (sent message)
      _typingTimer?.cancel();
      _isCurrentlyTrackedAsTyping = false;
      await _typingChannel?.track({
        'user_id': _currentUserId,
        'is_typing': false,
      });
    }
  }
}

// ─── Private realtime events — not exposed outside the bloc ──────────────────

class _NewRealtimeMessageEvent extends SquadMissionEvent {
  final Map<String, dynamic> raw;
  _NewRealtimeMessageEvent({required this.raw});
}

class _MemberJoinedEvent extends SquadMissionEvent {
  final Map<String, dynamic> raw;
  _MemberJoinedEvent({required this.raw});
}

class _MemberLeftEvent extends SquadMissionEvent {
  final String userId;
  _MemberLeftEvent({required this.userId});
}

class _TypingPresenceChangedEvent extends SquadMissionEvent {
  final List<SinglePresenceState> presenceState;
  _TypingPresenceChangedEvent({required this.presenceState});
}
