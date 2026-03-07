import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/app/view/widgets/gradient_progress.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/model/mission_status_enum.dart';
import '../../data/model/social_mission_model.dart';
import '../bloc/social_mission_bloc.dart';
import 'social_event_dialog.dart';

class FollowUsCard extends StatefulWidget {
  FollowUsCard({super.key});

  @override
  State<FollowUsCard> createState() => _FollowUsCardState();
}

class _FollowUsCardState extends State<FollowUsCard> {
  List<SocialMission> socialMissions = [];
  List<MissionStatus> socialMissionStatus = [];
  @override
  void initState() {
    final socialBloc = BlocProvider.of<SocialMissionBloc>(context);
    socialBloc.add(LoadSocialMission());
    socialMissions = socialBloc.state.missions;
    socialMissionStatus = socialBloc.state.hasJoined;
    super.initState();
  }

  String getMissionPointRange() {
    final points = socialMissions
        .map((p) => p.points)
        .whereType<int>()
        .toList();

    if (points.isEmpty) {
      throw Exception('No point-based missions found');
    }

    final min = points.reduce((a, b) => a < b ? a : b);
    final max = points.reduce((a, b) => a > b ? a : b);

    if (min == max) {
      return min.toString();
    }

    return "$min - $max";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 13.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: BlocBuilder<SocialMissionBloc, SocialMissionState>(
        builder: (context, state) {
          socialMissions = state.missions;
          socialMissionStatus = state.hasJoined;

          final activeStatusLength = socialMissionStatus
              .where(
                (e) =>
                    (e == MissionStatus.completed ||
                    e == MissionStatus.pending),
              )
              .toList()
              .length;

          final int total = socialMissions.length;

          final double progress = total == 0 ? 0.0 : activeStatusLength / total;

          final double safeProgress = progress.clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  color: AppColors.white80,
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                child: Row(
                  spacing: 4.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: 'Bravoo Social mission 🔥',
                          style: TextStyles.titleBold20(
                            context,
                          ).copyWith(fontFamily: AppFonts.baloo2),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black40,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        spacing: 4.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(),
                          Image.asset(
                            AssetsPngImages.one50,
                            height: 14.r,
                            width: 14.r,
                          ),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: getMissionPointRange(),
                              style: TextStyles.cardSemibold10(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              RichText(
                text: TextSpan(
                  text: "Total Progress 0%",
                  style: TextStyles.cardSemibold10(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
              ),
              SizedBox(height: 7.h),
              // Progress bar area with markers and icons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GradientProgress(height: 8, progress: safeProgress),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "0%",
                              style: TextStyles.smallCardSemibold8(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "33%",
                              style: TextStyles.smallCardSemibold8(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "67%",
                              style: TextStyles.smallCardSemibold8(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "100%",
                            style: TextStyles.smallCardSemibold8(
                              context,
                            ).copyWith(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.r),
                    // Three tier cards row: Beginner / Explorer / Master
                    Row(
                      spacing: 12.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: socialMissions.asMap().entries.map((e) {
                        final index = e.key;
                        final socialMission = socialMissions[index];
                        final missionStatus = socialMissionStatus[index];

                        return Expanded(
                          child: _SocialCard(
                            socialMission: socialMission,
                            missionStatus: missionStatus,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final SocialMission socialMission;
  final MissionStatus missionStatus;

  _SocialCard({required this.socialMission, required this.missionStatus});

  @override
  Widget build(BuildContext context) {
    final joined =
        (missionStatus == MissionStatus.pending ||
        missionStatus == MissionStatus.completed);
    // container with rounded corners and subtle background
    return GestureDetector(
      onTap: () {
        if (!joined) {
          socialEventDialog(socialMission: socialMission);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: joined ? Color(0xFFECD6FF) : AppColors.black05,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(width: 1.w, color: AppColors.white),
        ),
        child: Stack(
          children: [
            Column(
              spacing: 7.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedImageRadius(
                  imageUrl: socialMission.image,
                  size: 32,
                  circle: true,
                  fit: BoxFit.contain,
                ),
                RichText(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: socialMission.title,
                    style: TextStyles.cardBold10(
                      context,
                    ).copyWith(color: !joined ? AppColors.white : null),
                  ),
                ),
                joined
                    ? Image.asset(
                        AssetsPngImages.check,
                        width: 14.r,
                        height: 14.r,
                        fit: BoxFit.contain,
                      )
                    : IconTextButton(
                        onPressed: () {
                          if (!joined) {
                            socialEventDialog(socialMission: socialMission);
                          }
                        },
                        height: 22.5,
                        textSize: 6.5,
                        text: "Start Mission",
                        paddingH: 0,
                        paddingW: 0,
                        color: joined ? AppColors.grey300 : AppColors.black,
                        textColor: AppColors.white,
                      ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                AssetsSvgIcons.circleLock,
                width: 14.r,
                height: 14.r,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  !joined ? AppColors.white : AppColors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
