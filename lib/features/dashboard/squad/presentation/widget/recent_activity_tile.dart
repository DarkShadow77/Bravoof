import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/date_time_helper.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../mission/data/model/featured_mission_model.dart';
import '../../data/model/response/recent_activity_model.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.activity,
    required this.onReact,
  });

  final RecentActivity activity;
  final Function(ReactionEmoji) onReact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 1.w, color: AppColors.grey300),
      ),
      child: Column(
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 8.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageRadius(
                imageUrl: activity.user.profileImage,
                size: 32,
                circle: true,
                color: AppColors.grey200,
                fit: BoxFit.cover,
              ),
              Column(
                spacing: 4.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 4.w,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: activity.user.name.capitalize,
                            style: TextStyles.normalMedium14(context),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        color: AppColors.black,
                        size: 24.sp,
                      ),
                      Flexible(child: _buildActivityTitle(context)),
                    ],
                  ),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: formatSMHDTime(
                        activity.createdAt.toIso8601String(),
                      ),
                      style: TextStyles.cardMedium10(
                        context,
                      ).copyWith(color: AppColors.grey400),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildImageCover(context),
          MarkdownBody(
            data: activity.message,
            onTapLink: (text, href, title) async {
              if (href != null) {
                final uri = Uri.parse(href);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            styleSheet: MarkdownStyleSheet(
              a: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
              p: TextStyles.normalMedium14(context),
              strong: TextStyles.normalBold14(context),
            ),
          ),
          ReactionRow(
            activity: activity,
            onReact: (reaction) => onReact(reaction),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTitle(BuildContext context) {
    switch (activity.activityType) {
      case ActivityType.followBrand:
      case ActivityType.startBrandMission:
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: (activity.brand?.name ?? "").capitalize,
            style: TextStyles.normalMedium14(context, opacity: .6),
          ),
        );
      case ActivityType.joinSquad:
      case ActivityType.startSquadMission:
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: "${(activity.squad?.name ?? "").capitalize}",
            style: TextStyles.normalMedium14(context, opacity: .6),
          ),
        );
      case ActivityType.unknown:
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: "Activity",
            style: TextStyles.normalMedium14(context, opacity: .6),
          ),
        );
    }
  }

  Widget _buildActivityLogo(BuildContext context) {
    switch (activity.activityType) {
      case ActivityType.followBrand:
      case ActivityType.startBrandMission:
        return Container(
          height: 66.h,
          width: 66.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hexToColor(activity.brand?.logoBgColor ?? "#FFFFFF"),
          ),
          child: Center(
            child: CachedImageRadius(
              imageUrl: activity.brand?.logo ?? "",
              size: 40,
              fit: BoxFit.contain,
              color: Colors.transparent,
            ),
          ),
        );
      case ActivityType.joinSquad:
      case ActivityType.startSquadMission:
        return Container(
          height: 66.h,
          width: 66.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexToColor(gradientColor.end),
                hexToColor(gradientColor.start),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white50, width: 3.w),
          ),
          child: Center(
            child: CachedImageRadius(
              imageUrl: activity.squad?.image ?? "",
              circle: true,
              size: 50,
              fit: BoxFit.cover,
              color: Colors.transparent,
            ),
          ),
        );
      case ActivityType.unknown:
        return Container(
          height: 66.h,
          width: 66.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexToColor(gradientColor.end),
                hexToColor(gradientColor.start),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white50, width: 3.w),
          ),
        );
    }
  }

  MissionGradient get gradientColor {
    switch (activity.activityType) {
      case ActivityType.followBrand:
      case ActivityType.startBrandMission:
        return activity.brand?.gradientColor ?? MissionGradient.fallback();

      case ActivityType.joinSquad:
      case ActivityType.startSquadMission:
        return activity.squad?.gradientColor ?? MissionGradient.fallback();

      case ActivityType.unknown:
        return MissionGradient.fallback();
    }
  }

  Widget _buildImageCover(BuildContext context) {
    const double avatarSize = 66;
    const double overlap = 48.5;
    const int maxParticipantsShown = 3;
    switch (activity.activityType) {
      case ActivityType.followBrand:
      case ActivityType.joinSquad:
        final double totalWidth = avatarSize + overlap;
        return Center(
          child: SizedBox(
            height: avatarSize.h,
            width: totalWidth.w,
            child: Stack(
              children: [
                // User avatar sits behind, at left: 0
                Positioned(
                  left: 0,
                  child: _buildBorderedAvatar(
                    imageUrl: activity.user.profileImage,
                    size: avatarSize,
                  ),
                ),
                // Brand/squad logo sits in front, offset right
                Positioned(left: overlap.w, child: _buildActivityLogo(context)),
              ],
            ),
          ),
        );
      case ActivityType.startSquadMission:
      case ActivityType.startBrandMission:
        final participants = activity.missionParticipants;
        final shown = participants.take(maxParticipantsShown).toList();
        final overflow = participants.length - maxParticipantsShown;
        // Total items = shown avatars + optional +N bubble
        final itemCount = shown.length + (overflow > 0 ? 1 : 0);
        final double totalWidth = avatarSize + (itemCount - 1) * overlap;

        return Center(
          child: SizedBox(
            height: avatarSize.h,
            width: totalWidth.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Render avatars back-to-front so later ones overlap earlier
                ...List.generate(shown.length, (i) {
                  return Positioned(
                    left: (i * overlap).w,
                    child: _buildBorderedAvatar(
                      imageUrl: shown[i].profileImage,
                      size: avatarSize,
                    ),
                  );
                }),
                // +N bubble on top of the last avatar
                if (overflow > 0)
                  Positioned(
                    left: (shown.length * overlap).w,
                    child: Container(
                      height: avatarSize.h,
                      width: avatarSize.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            hexToColor(gradientColor.end),
                            hexToColor(gradientColor.start),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white50,
                          width: 3.w,
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                            text: '+${formatAmount(overflow, uniComp: true)}',
                            style: TextStyles.titleSemiBold20(context).copyWith(
                              color: hexToColor(
                                activity.squad?.textColor ??
                                    activity.brand?.textColor ??
                                    '#FFFFFF',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      case ActivityType.unknown:
        return SizedBox(
          height: avatarSize.h,
          width: avatarSize.w,
          child: _buildBorderedAvatar(
            imageUrl: activity.user.profileImage,
            size: avatarSize,
          ),
        );
    }
  }

  Widget _buildBorderedAvatar({
    required String? imageUrl,
    required double size,
  }) {
    return SizedBox(
      height: size.h,
      width: size.w,
      child: Stack(
        children: [
          Center(
            child: CachedImageRadius(
              imageUrl: imageUrl ?? "",
              circle: true,
              size: size,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white50, width: 3.w),
            ),
          ),
        ],
      ),
    );
  }
}

class ReactionRow extends StatelessWidget {
  const ReactionRow({super.key, required this.activity, required this.onReact});

  final RecentActivity activity;
  final Function(ReactionEmoji) onReact;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ReactionButton(
          emoji: ReactionEmoji.heart,
          icon: AssetsSvgIcons.heart,
          iconActive: AssetsSvgIcons.heartFilled,
          count: activity.reactions.heart,
          isActive: activity.reactions.hasReacted(ReactionEmoji.heart),
          onTap: () => onReact(ReactionEmoji.heart),
        ),
        _ReactionButton(
          emoji: ReactionEmoji.fire,
          icon: AssetsSvgIcons.fire,
          iconActive: AssetsSvgIcons.fireFilled,
          count: activity.reactions.fire,
          isActive: activity.reactions.hasReacted(ReactionEmoji.fire),
          onTap: () => onReact(ReactionEmoji.fire),
        ),
        _ReactionButton(
          isTextEmoji: true,
          emoji: ReactionEmoji.hundred,
          icon: AssetsSvgIcons.hundred,
          iconActive: AssetsSvgIcons.hundred,
          count: activity.reactions.hundred,
          isActive: activity.reactions.hasReacted(ReactionEmoji.hundred),
          onTap: () => onReact(ReactionEmoji.hundred),
        ),
        _ReactionButton(
          isTextEmoji: true,
          emoji: ReactionEmoji.clap,
          icon: AssetsSvgIcons.clap,
          iconActive: AssetsSvgIcons.clap,
          count: activity.reactions.clap,
          isActive: activity.reactions.hasReacted(ReactionEmoji.clap),
          onTap: () => onReact(ReactionEmoji.clap),
        ),
      ],
    );
  }
}

class _ReactionButton extends StatefulWidget {
  const _ReactionButton({
    this.isTextEmoji = false,
    required this.emoji,
    required this.icon,
    required this.iconActive,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final bool isTextEmoji;
  final ReactionEmoji emoji;
  final String icon;
  final String iconActive;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late bool _isActive;
  late int _count;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    _count = widget.count;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    setState(() {
      _isActive = !_isActive;
      _count = _isActive ? _count + 1 : _count - 1;
    });

    // Pop animation: scale up then back
    await _controller.forward();
    await _controller.reverse();

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        width: 40.w,
        height: 32.h,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isActive ? AppColors.primary10 : AppColors.grey100,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _scale,
                child: widget.isTextEmoji
                    ? RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: widget.emoji.emoji,
                          style: TextStyles.smallMedium12(context),
                        ),
                      )
                    : SvgPicture.asset(
                        _isActive ? widget.iconActive : widget.icon,
                        width: 16.w,
                        height: 16.h,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.darkPrimary10,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: RichText(
                    maxLines: 1,
                    key: ValueKey(_count),
                    text: TextSpan(
                      text: formatAmount(_count, uniComp: true),
                      style: TextStyles.cardMedium10(
                        context,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
