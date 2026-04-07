import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import 'package:uuid/uuid.dart';

import '../../data/model/response/squad_mission_chat_model.dart';
import '../../data/repository/squad_repository.dart';

part 'squad_mission_event.dart';
part 'squad_mission_state.dart';

class SquadMissionBloc extends Bloc<SquadMissionEvent, SquadMissionState> {
  final SquadRepository repo;
  final String squadId;
  final int missionId;

  final supabase = Supabase.instance.client;
  final _uuid = const Uuid();

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

    final res = await repo.joinSquadMission(missionId: missionId);

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
      (message) => emit(
        SquadMissionSuccessState(
          type: SquadMissionType.joinMission,
          missionId: missionId,
          message: message,
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

    final res = await repo.fetchMissionMembers(missionId: missionId);

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
        emit(state.copWith(missionMembers: members));

        emit(
          SquadMissionSuccessState(
            type: SquadMissionType.fetchMissionMembers,
            missionId: missionId,
            message: "Fetched Members Successfully",
            missionMembers: members,
            chatResponse: state.chatResponse,
          ),
        );
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

    final res = await repo.leaveSquadMission(missionId: missionId);

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

    final res = await repo.fetchChat(missionId: missionId);

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
        // Prepend older messages in front of existing ones.
        // olderChat.messages is already sorted oldest→newest by the server.
        // Filter out any local pending/failed messages that are still in
        // the list to avoid duplicates when we eventually get them from server.
        final existingMessages = state.chatResponse?.messages ?? [];

        final merged = [
          ...olderChat.messages, // older page goes first (top of chat)
          ...existingMessages,
        ];

        final updatedChat = (state.chatResponse ?? olderChat).copyWith(
          messages: merged,
          hasMore: olderChat.hasMore, // update pagination flag
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

    // 1. Build an optimistic pending message and append it to the list
    final optimisticMessage = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch, // temp negative ID
      chatRoomId: event.chatRoomId,
      userId: event.currentUserId,
      isSystem: false,
      content: event.content,
      mediaUrl: event.media, // local file path — your UI can handle this
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

    final messagesWithOptimistic = [
      ...(state.chatResponse?.messages ?? []),
      optimisticMessage, // newest at end (bottom of chat)
    ];

    _emitWithMessages(emit, messagesWithOptimistic);

    // 2. Actually send
    final res = await repo.sendMissionChat(
      missionId: missionId,
      chatRoomId: event.chatRoomId,
      content: event.content,
      replyToId: event.replyToId,
      media: event.media,
    );

    res.fold(
      (err) {
        // Mark the optimistic message as failed
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
        // Replace optimistic message with real one from server
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
      image: event.image,
      text: event.text,
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
}
