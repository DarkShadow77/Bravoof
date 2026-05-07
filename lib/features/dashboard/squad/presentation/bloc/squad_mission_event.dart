part of 'squad_mission_bloc.dart';

@immutable
abstract class SquadMissionEvent {}

class JoinSquadMissionEvent extends SquadMissionEvent {}

class FetchSquadMissionMembersEvent extends SquadMissionEvent {}

class LeaveSquadMissionEvent extends SquadMissionEvent {}

class FetchSquadMissionChatEvent extends SquadMissionEvent {}

class FetchMoreSquadMissionChatEvent extends SquadMissionEvent {
  final String before;

  FetchMoreSquadMissionChatEvent({required this.before});
}

class SendSquadMissionMessageEvent extends SquadMissionEvent {
  final int chatRoomId;
  final String? content;
  final String? replyToId;
  final String? media;
  final String currentUserId;
  final ChatMessageSender? currentUserSender;
  final ChatMessageReply? replyToMessage;

  SendSquadMissionMessageEvent({
    required this.chatRoomId,
    this.content,
    this.replyToId,
    this.media,
    required this.currentUserId,
    this.currentUserSender,
    this.replyToMessage,
  });
}

class RetrySendSquadMissionMessageEvent extends SquadMissionEvent {
  final String localId;
  RetrySendSquadMissionMessageEvent({required this.localId});
}

class SubmitSquadMissionEvent extends SquadMissionEvent {
  final String? image;
  final String? text;
  final bool isVideo;

  SubmitSquadMissionEvent({this.image, this.text, required this.isVideo});
}

class UserTypingEvent extends SquadMissionEvent {
  final bool isTyping;
  UserTypingEvent({required this.isTyping});
}
