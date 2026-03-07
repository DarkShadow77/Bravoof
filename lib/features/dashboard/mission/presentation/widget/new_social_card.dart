import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../app/view/widgets/gradient_progress.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/utils/helpers.dart';
import '../../data/model/mission_status_enum.dart';
import '../../data/model/new_social_mission_model.dart';
import 'new_social_event_dialog.dart';

class NewSocialCard extends StatelessWidget {
  const NewSocialCard({
    super.key,
    required this.socialMission,
    required this.missionStatus,
  });

  final NewSocialMission socialMission;
  final MissionStatus missionStatus;

  @override
  Widget build(BuildContext context) {
    final double progress = socialMission.maxUsers == 0
        ? 0.0
        : socialMission.usersJoined / socialMission.maxUsers;
    final double safeProgress = progress.clamp(0.0, 1.0);

    final joined =
        (missionStatus == MissionStatus.pending ||
        missionStatus == MissionStatus.completed);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 13.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(socialMission.color.end),
            hexToColor(socialMission.color.start),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: hexToColor(
                    socialMission.textColor,
                  ).withValues(alpha: .8),
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                child: Row(
                  spacing: 8.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 40.w),
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: socialMission.title.capitalize,
                          style: TextStyles.titleBold20(context).copyWith(
                            fontFamily: AppFonts.baloo2,
                            color: hexToColor(socialMission.inverseTextColor),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            hexToColor(socialMission.color.end),
                            hexToColor(socialMission.color.start),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        spacing: 4.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AssetsPngImages.one50,
                            height: 14.r,
                            width: 14.r,
                          ),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: formatAmount(socialMission.points),
                              style: TextStyles.cardSemibold10(context)
                                  .copyWith(
                                    color: hexToColor(socialMission.textColor),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CachedImageRadius(
                  imageUrl: socialMission.image,
                  size: 48,
                  borderRadius: 14,
                  fit: BoxFit.cover,
                  color: hexToColor(socialMission.textColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text:
                              "Mission Progress ${formatAmount(safeProgress * 100)}%",
                          style: TextStyles.cardSemibold10(context).copyWith(
                            color: hexToColor(socialMission.textColor),
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text:
                            "${socialMission.usersJoined} / ${socialMission.maxUsers}",
                        style: TextStyles.cardRegular10(context).copyWith(
                          fontFamily: AppFonts.baloo,
                          color: hexToColor(socialMission.textColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                // Progress bar area with markers and icons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GradientProgress(
                        height: 8,
                        progress: safeProgress,
                        backgroundColor: hexToColor(
                          socialMission.textColor,
                        ).withValues(alpha: .2),
                        color: [
                          hexToColor(
                            socialMission.textColor,
                          ).withValues(alpha: .5),
                          hexToColor(socialMission.textColor),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "0%",
                                style: TextStyles.smallCardSemibold8(context)
                                    .copyWith(
                                      color: hexToColor(
                                        socialMission.textColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "33%",
                                style: TextStyles.smallCardSemibold8(context)
                                    .copyWith(
                                      color: hexToColor(
                                        socialMission.textColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "67%",
                                style: TextStyles.smallCardSemibold8(context)
                                    .copyWith(
                                      color: hexToColor(
                                        socialMission.textColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "100%",
                              style: TextStyles.smallCardSemibold8(context)
                                  .copyWith(
                                    color: hexToColor(socialMission.textColor),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.r),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              color: hexToColor(socialMission.textColor).withValues(alpha: .75),
            ),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                RichText(
                  text: TextSpan(
                    text: socialMission.subtitle,
                    style: TextStyles.smallMedium12(context).copyWith(
                      color: hexToColor(socialMission.inverseTextColor),
                    ),
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
                            newSocialEventDialog(
                              newSocialMission: socialMission,
                            );
                          }
                        },
                        textSize: 11,
                        text: "Start Mission",
                        color: joined
                            ? AppColors.grey300
                            : hexToColor(socialMission.inverseTextColor),
                        textColor: hexToColor(socialMission.textColor),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
