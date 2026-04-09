import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../data/model/response/squad_mission_chat_model.dart';
import '../bloc/squad_mission_bloc.dart';

class SquadMissionChatPage extends StatefulWidget {
  const SquadMissionChatPage({
    super.key,
    required this.missionTitle,
    required this.chatRoomId,
    required this.missionId,
  });

  final String missionTitle;
  final int chatRoomId;
  final int missionId;

  @override
  State<SquadMissionChatPage> createState() => _SquadMissionChatPageState();
}

class _SquadMissionChatPageState extends State<SquadMissionChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  ChatMessage? _replyingTo;
  String? _selectedMediaPath;
  bool _isImage = true;

  final _currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SquadMissionBloc>();
    bloc.add(FetchSquadMissionChatEvent());
    bloc.add(FetchSquadMissionMembersEvent());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when user scrolls near the top
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      final state = context.read<SquadMissionBloc>().state;
      final hasMore = state.chatResponse?.hasMore ?? false;
      if (hasMore) {
        final messages = state.chatResponse?.messages ?? [];
        if (messages.isNotEmpty) {
          context.read<SquadMissionBloc>().add(
            FetchMoreSquadMissionChatEvent(
              before: messages.first.createdAt.toIso8601String(),
            ),
          );
        }
      }
    }
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty && _selectedMediaPath == null) return;

    // Stop typing indicator when message is sent
    context.read<SquadMissionBloc>().add(UserTypingEvent(isTyping: false));

    final state = context.read<SquadMissionBloc>().state;
    final currentMember = state.missionMembers.firstWhere(
      (m) => m.userId == _currentUserId,
      orElse: () => MissionChatMember(
        userId: _currentUserId,
        joinedAt: DateTime.now(),
        isCaptain: false,
      ),
    );

    context.read<SquadMissionBloc>().add(
      SendSquadMissionMessageEvent(
        chatRoomId: widget.chatRoomId,
        content: content.isEmpty ? null : content,
        replyToId: _replyingTo?.id.toString(),
        media: _selectedMediaPath,
        currentUserId: _currentUserId,
        currentUserSender: ChatMessageSender(
          userId: _currentUserId,
          name: currentMember.name,
          profileImage: currentMember.profileImage,
        ),
        replyToMessage: _replyingTo != null
            ? ChatMessageReply(
                id: _replyingTo!.id,
                content: _replyingTo!.content,
                mediaUrl: _replyingTo!.mediaUrl,
                mediaType: _replyingTo!.mediaType,
                userId: _replyingTo!.userId,
                sender: _replyingTo!.sender,
              )
            : null,
      ),
    );

    _messageController.clear();
    setState(() {
      _replyingTo = null;
      _selectedMediaPath = null;
    });
    _scrollToBottom();
  }

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    try {
      XFile? file;
      if (isVideo) {
        file = await _imagePicker.pickVideo(source: source);
      } else {
        file = await _imagePicker.pickImage(source: source, imageQuality: 80);
      }
      if (file != null) {
        setState(() {
          _selectedMediaPath = file!.path;
          _isImage = !isVideo;
        });
      }
    } catch (_) {}
  }

  void _showMediaPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              _MediaOption(
                icon: HugeIcons.strokeRoundedCamera01,
                label: 'Camera Photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera);
                },
              ),
              _MediaOption(
                icon: HugeIcons.strokeRoundedImage01,
                label: 'Photo Library',
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery);
                },
              ),
              _MediaOption(
                icon: HugeIcons.strokeRoundedVideo01,
                label: 'Video',
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, isVideo: true);
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/earn_bg.png', fit: BoxFit.fill),
          ),
          Column(
            children: [
              _ChatAppBar(
                missionTitle: widget.missionTitle,
                missionId: widget.missionId,
              ),
              Expanded(
                child: BlocConsumer<SquadMissionBloc, SquadMissionState>(
                  listenWhen: (prev, curr) =>
                      curr is SquadMissionSuccessState &&
                      (curr.type == SquadMissionType.sendMissionChat ||
                          curr.type == SquadMissionType.fetchChat),
                  listener: (context, state) => _scrollToBottom(),
                  builder: (context, state) {
                    final messages = state.chatResponse?.messages ?? [];
                    final isLoadingMore =
                        state is SquadMissionLoadingState &&
                        state.type == SquadMissionType.fetchMoreChat;
                    final isLoading =
                        state is SquadMissionLoadingState &&
                        state.type == SquadMissionType.fetchChat;

                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      itemCount: messages.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isLoadingMore && index == 0) {
                          return Padding(
                            padding: EdgeInsets.all(8.r),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        final msgIndex = isLoadingMore ? index - 1 : index;
                        final message = messages[msgIndex];

                        if (message.isSystem) {
                          return _SystemMessageBubble(message: message);
                        }

                        final isMe = message.userId == _currentUserId;
                        final showAvatar = !isMe;
                        final isSameUserAsPrev =
                            msgIndex > 0 &&
                            messages[msgIndex - 1].userId == message.userId &&
                            !messages[msgIndex - 1].isSystem;

                        return _ChatMessageBubble(
                          key: ValueKey(message.localId ?? message.id),
                          message: message,
                          isMe: isMe,
                          showAvatar: showAvatar && !isSameUserAsPrev,
                          avatarPlaceholder: showAvatar && isSameUserAsPrev,
                          onReply: (msg) {
                            setState(() => _replyingTo = msg);
                            _focusNode.requestFocus();
                          },
                          onRetry: message.isFailed && message.localId != null
                              ? () => context.read<SquadMissionBloc>().add(
                                  RetrySendSquadMissionMessageEvent(
                                    localId: message.localId!,
                                  ),
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              _TypingIndicator(),
              _ChatInputBar(
                controller: _messageController,
                focusNode: _focusNode,
                replyingTo: _replyingTo,
                selectedMedia: _selectedMediaPath,
                isImage: _isImage,
                onCancelReply: () => setState(() => _replyingTo = null),
                onCancelMedia: () => setState(() => _selectedMediaPath = null),
                onPickMedia: _showMediaPicker,
                onSend: _sendMessage,
                onTypingChanged: (isTyping) {
                  context.read<SquadMissionBloc>().add(
                    UserTypingEvent(isTyping: isTyping),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── App Bar ─────────────────────────────────────────────────────────────────

class _ChatAppBar extends StatelessWidget {
  const _ChatAppBar({required this.missionTitle, required this.missionId});

  final String missionTitle;
  final int missionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SquadMissionBloc, SquadMissionState>(
      builder: (context, state) {
        final members = state.missionMembers;
        final preview = members.take(5).toList();

        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8.h,
            bottom: 12.h,
            left: 12.w,
            right: 16.w,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.r,
                    color: AppColors.darkPrimary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: missionTitle,
                        style: TextStyles.bodyBold16(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    if (members.isNotEmpty)
                      Text(
                        '${members.length} member${members.length == 1 ? '' : 's'}',
                        style: TextStyles.smallSemibold12(
                          context,
                          opacity: .55,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Member avatars row
              if (preview.isNotEmpty)
                SizedBox(
                  width: (preview.length * 22.0 + 14).w,
                  height: 36.h,
                  child: Stack(
                    children: [
                      for (int i = preview.length - 1; i >= 0; i--)
                        Positioned(
                          left: i * 22.0.w,
                          child: _MemberAvatar(
                            member: preview[i],
                            isCaptain: preview[i].isCaptain,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.member, required this.isCaptain});

  final MissionChatMember member;
  final bool isCaptain;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCaptain ? AppColors.primary : AppColors.white,
              width: isCaptain ? 2 : 1.5,
            ),
          ),
          child: ClipOval(
            child: member.profileImage != null
                ? CachedImageSize(
                    imageUrl: member.profileImage!,
                    width: 34.r,
                    height: 34.r,
                    fit: BoxFit.cover,
                    child: const SizedBox.shrink(),
                  )
                : _DefaultAvatar(name: member.name),
          ),
        ),
        if (isCaptain)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 14.r,
              height: 14.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.white,
                size: 8.r,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Message Bubbles ──────────────────────────────────────────────────────────

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.avatarPlaceholder,
    required this.onReply,
    this.onRetry,
  });

  final ChatMessage message;
  final bool isMe;
  final bool showAvatar;
  final bool avatarPlaceholder;
  final void Function(ChatMessage) onReply;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? AppColors.primary
        : AppColors.white.withValues(alpha: 0.92);
    final textColor = isMe ? AppColors.white : AppColors.darkPrimary;
    final avatarSize = 30.r;

    return GestureDetector(
      onLongPress: () => onReply(message),
      child: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar (other users)
            if (!isMe)
              SizedBox(
                width: avatarSize + 6.w,
                child: showAvatar
                    ? Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: ClipOval(
                          child: message.sender?.profileImage != null
                              ? CachedImageSize(
                                  imageUrl: message.sender!.profileImage!,
                                  width: avatarSize,
                                  height: avatarSize,
                                  fit: BoxFit.cover,
                                  child: const SizedBox.shrink(),
                                )
                              : _DefaultAvatar(
                                  name: message.sender?.name,
                                  size: avatarSize,
                                ),
                        ),
                      )
                    : SizedBox(width: avatarSize + 6.w),
              ),
            // Bubble
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 270.w),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Sender name (first in group only)
                    if (!isMe && showAvatar && message.sender?.name != null)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
                        child: Text(
                          message.sender!.name!,
                          style: TextStyles.smallSemibold12(context).copyWith(
                            color: AppColors.primary,
                            fontFamily: AppFonts.baloo2,
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                          bottomLeft: isMe
                              ? Radius.circular(16.r)
                              : Radius.circular(4.r),
                          bottomRight: isMe
                              ? Radius.circular(4.r)
                              : Radius.circular(16.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reply preview
                          if (message.replyTo != null)
                            _ReplyPreview(reply: message.replyTo!, isMe: isMe),
                          // Media
                          if (message.isMedia)
                            _MediaContent(message: message, isMe: isMe),
                          // Text
                          if (message.content != null &&
                              message.content!.isNotEmpty)
                            Text(
                              message.content!,
                              style: TextStyles.normalRegular14(
                                context,
                              ).copyWith(color: textColor),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Timestamp + status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('h:mm a').format(message.createdAt),
                          style: TextStyles.smallSemibold12(
                            context,
                            opacity: .45,
                          ).copyWith(fontSize: 10.sp),
                        ),
                        if (isMe) ...[
                          SizedBox(width: 4.w),
                          _StatusIcon(message: message, onRetry: onRetry),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Spacer on right for other user messages
            if (!isMe) SizedBox(width: 40.w),
          ],
        ),
      ),
    );
  }
}

class _SystemMessageBubble extends StatelessWidget {
  const _SystemMessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // System avatar
          Container(
            width: 30.r,
            height: 30.r,
            margin: EdgeInsets.only(right: 6.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.darkPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(Icons.bolt_rounded, color: AppColors.white, size: 16.r),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.darkPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(4.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Text(
                message.content ?? '',
                style: TextStyles.smallSemibold12(context, opacity: .75),
              ),
            ),
          ),
          SizedBox(width: 50.w),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.reply, required this.isMe});
  final ChatMessageReply reply;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final borderColor = isMe
        ? AppColors.white.withValues(alpha: 0.5)
        : AppColors.primary.withValues(alpha: 0.5);
    final textColor = isMe ? AppColors.white : AppColors.darkPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
        color: isMe
            ? AppColors.white.withValues(alpha: 0.15)
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reply.sender?.name != null)
            Text(
              reply.sender!.name!,
              style: TextStyles.smallSemibold12(context).copyWith(
                color: isMe
                    ? AppColors.white.withValues(alpha: 0.85)
                    : AppColors.primary,
                fontSize: 11.sp,
              ),
            ),
          if (reply.content != null)
            Text(
              reply.content!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.smallSemibold12(
                context,
                opacity: .7,
              ).copyWith(color: textColor.withValues(alpha: 0.7)),
            )
          else if (reply.mediaUrl != null)
            Row(
              children: [
                Icon(
                  reply.mediaType == 'video'
                      ? Icons.videocam_rounded
                      : Icons.image_rounded,
                  size: 14.r,
                  color: textColor.withValues(alpha: 0.6),
                ),
                SizedBox(width: 4.w),
                Text(
                  reply.mediaType == 'video' ? 'Video' : 'Photo',
                  style: TextStyles.smallSemibold12(
                    context,
                    opacity: .6,
                  ).copyWith(color: textColor.withValues(alpha: 0.6)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MediaContent extends StatelessWidget {
  const _MediaContent({required this.message, required this.isMe});
  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final isLocal =
        message.mediaUrl != null &&
        !message.mediaUrl!.startsWith('http') &&
        !message.isPending == false;

    return Padding(
      padding: EdgeInsets.only(bottom: message.content != null ? 6.h : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: message.isVideo
            ? _VideoThumbnail(url: message.mediaUrl!)
            : (isLocal || (message.isPending && message.mediaUrl != null))
            ? Image.file(
                File(message.mediaUrl!),
                width: 200.w,
                height: 160.h,
                fit: BoxFit.cover,
              )
            : CachedImageSize(
                imageUrl: message.mediaUrl!,
                width: 200.w,
                height: 160.h,
                fit: BoxFit.cover,
                child: const SizedBox.shrink(),
              ),
      ),
    );
  }
}

class _VideoThumbnail extends StatefulWidget {
  const _VideoThumbnail({required this.url});
  final String url;

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.url);
    if (uri != null && widget.url.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200.w,
          height: 160.h,
          color: AppColors.darkPrimary.withValues(alpha: 0.1),
          child: _controller?.value.isInitialized == true
              ? VideoPlayer(_controller!)
              : const SizedBox.shrink(),
        ),
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: AppColors.white,
            size: 24.r,
          ),
        ),
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.message, this.onRetry});
  final ChatMessage message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (message.isPending) {
      return Icon(
        Icons.access_time_rounded,
        size: 12.r,
        color: AppColors.darkPrimary.withValues(alpha: 0.4),
      );
    }
    if (message.isFailed) {
      return GestureDetector(
        onTap: onRetry,
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 12.r,
              color: Colors.redAccent,
            ),
            SizedBox(width: 2.w),
            Text(
              'Retry',
              style: TextStyles.smallSemibold12(
                context,
              ).copyWith(color: Colors.redAccent, fontSize: 10.sp),
            ),
          ],
        ),
      );
    }
    return Icon(
      Icons.done_all_rounded,
      size: 12.r,
      color: AppColors.white.withValues(alpha: 0.7),
    );
  }
}

// ─── Typing Indicator  ────────────────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SquadMissionBloc, SquadMissionState>(
      buildWhen: (prev, curr) =>
          prev.typingUserIds != curr.typingUserIds ||
          prev.missionMembers != curr.missionMembers,
      builder: (context, state) {
        final typingIds = state.typingUserIds;
        if (typingIds.isEmpty) return const SizedBox.shrink();

        // Resolve members who are typing
        final typingMembers = typingIds.map((id) {
          return state.missionMembers.firstWhere(
            (m) => m.userId == id,
            orElse: () => MissionChatMember(
              userId: id,
              joinedAt: DateTime.now(),
              isCaptain: false,
            ),
          );
        }).toList();

        // Captain goes first
        typingMembers.sort((a, b) {
          if (a.isCaptain) return -1;
          if (b.isCaptain) return 1;
          return 0;
        });

        const maxVisible = 5;
        final visible = typingMembers.take(maxVisible).toList();
        final overflow = typingMembers.length - maxVisible;

        return Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 6.h, top: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Stacked avatars
              SizedBox(
                height: 28.r,
                width: (visible.length * 20.0 + (overflow > 0 ? 28.0 : 8.0)).w,
                child: Stack(
                  children: [
                    for (int i = visible.length - 1; i >= 0; i--)
                      Positioned(
                        left: (i * 20.0).w,
                        child: _TypingAvatar(member: visible[i], size: 28.r),
                      ),
                    // +N overflow circle
                    if (overflow > 0)
                      Positioned(
                        left: (visible.length * 20.0).w,
                        child: Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '+$overflow',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _TypingDots(),
            ],
          ),
        );
      },
    );
  }
}

class _TypingAvatar extends StatelessWidget {
  const _TypingAvatar({required this.member, required this.size});
  final MissionChatMember member;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: member.isCaptain ? AppColors.primary : AppColors.white,
          width: member.isCaptain ? 2 : 1.5,
        ),
      ),
      child: ClipOval(
        child: member.profileImage != null
            ? CachedImageSize(
                imageUrl: member.profileImage!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                child: const SizedBox.shrink(),
              )
            : _DefaultAvatar(name: member.name, size: size),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Each dot animates with a 200ms offset
            final delay = i * 0.3;
            final t = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 6.r * scale,
              height: 6.r * scale,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────────────────────

class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar({
    required this.controller,
    required this.focusNode,
    required this.replyingTo,
    required this.selectedMedia,
    required this.isImage,
    required this.onCancelReply,
    required this.onCancelMedia,
    required this.onPickMedia,
    required this.onSend,
    required this.onTypingChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ChatMessage? replyingTo;
  final String? selectedMedia;
  final bool isImage;
  final VoidCallback onCancelReply;
  final VoidCallback onCancelMedia;
  final VoidCallback onPickMedia;
  final VoidCallback onSend;
  final void Function(bool) onTypingChanged;

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    if (hasText) {
      widget.onTypingChanged(true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _hasText || widget.selectedMedia != null;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom + 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply banner
          if (widget.replyingTo != null)
            Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.replyingTo!.sender?.name ?? 'Reply',
                          style: TextStyles.smallSemibold12(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                        Text(
                          widget.replyingTo!.content ??
                              (widget.replyingTo!.isMedia
                                  ? (widget.replyingTo!.isVideo
                                        ? 'Video'
                                        : 'Photo')
                                  : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.smallSemibold12(
                            context,
                            opacity: .55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancelReply,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.r,
                      color: AppColors.darkPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          // Media preview
          if (widget.selectedMedia != null)
            Container(
              margin: EdgeInsets.only(bottom: 6.h),
              height: 80.h,
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: widget.isImage
                            ? Image.file(
                                File(widget.selectedMedia!),
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 80.w,
                                height: 80.h,
                                color: AppColors.darkPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  Icons.videocam_rounded,
                                  color: AppColors.primary,
                                  size: 32.r,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: widget.onCancelMedia,
                          child: Container(
                            width: 20.r,
                            height: 20.r,
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.white,
                              size: 12.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Input row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Media pick button
              GestureDetector(
                onTap: widget.onPickMedia,
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.07),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedAttachment01,
                    size: 18.r,
                    color: AppColors.darkPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              // Text field
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 120.h),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyles.normalRegular14(context),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyles.normalRegular14(
                        context,
                        opacity: .4,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => widget.onSend(),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Send button
              GestureDetector(
                onTap: canSend ? widget.onSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    boxShadow: canSend
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.white,
                    size: 18.r,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar({this.name, this.size});
  final String? name;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final initial = (name?.isNotEmpty == true) ? name![0].toUpperCase() : '?';
    final s = size ?? 30.r;

    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.darkPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: (s * 0.4).sp,
            fontFamily: AppFonts.baloo2,
          ),
        ),
      ),
    );
  }
}

class _MediaOption extends StatelessWidget {
  const _MediaOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: HugeIcon(icon: icon, color: AppColors.primary, size: 20.r),
      ),
      title: Text(label, style: TextStyles.normalSemibold14(context)),
    );
  }
}
