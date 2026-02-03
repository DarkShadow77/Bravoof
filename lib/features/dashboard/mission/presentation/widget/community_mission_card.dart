import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/app/view/widgets/gradient_progress.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/dashboard/mission/presentation/widget/community_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../data/model/community_mission_model.dart';
import '../../data/model/mission_status_enum.dart';
import '../bloc/community_mission_bloc.dart';

class CommunityMissionCard extends StatefulWidget {
  const CommunityMissionCard({super.key});

  @override
  State<CommunityMissionCard> createState() => _CommunityMissionCardState();
}

class _CommunityMissionCardState extends State<CommunityMissionCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityMissionBloc, CommunityMissionState>(
      builder: (context, state) {
        CommunityMission? communityMission = state.mission;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _TopSection(communityMission: communityMission),
                  SizedBox(height: 14.h),
                  _TimeSection(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [strokeConnector(), strokeConnector()],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget strokeConnector() {
    return Column(
      children: [
        // Top circle
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            color: AppColors.grey600,
            shape: BoxShape.circle,
          ),
        ),
        // Line
        Container(width: 4.w, height: 32.h, color: AppColors.grey500),
        // Bottom circle
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            color: AppColors.grey600,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.communityMission});

  final CommunityMission? communityMission;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFEFEF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.r, color: AppColors.black05),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5.r,
            color: Color(0xffBFBFBF).withValues(alpha: .1),
          ),
          BoxShadow(
            offset: Offset(0, 9),
            blurRadius: 9.r,
            color: Color(0xffBFBFBF).withValues(alpha: .09),
          ),
          BoxShadow(
            offset: Offset(0, 20),
            blurRadius: 12.r,
            color: Color(0xffBFBFBF).withValues(alpha: .05),
          ),
          BoxShadow(
            offset: Offset(0, 36),
            blurRadius: 14.r,
            color: Color(0xffBFBFBF).withValues(alpha: .01),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Community Mission",
              style: TextStyles.bigTitleBold24(context).copyWith(
                fontFamily: AppFonts.baloo2,
                color: Color(0xFF70403E),
                height: 1.sp,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primary10,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CachedImageRadius(
                  imageUrl: communityMission?.image ?? "",
                  size: 83,
                  fit: BoxFit.cover,
                  color: AppColors.white,
                  borderRadius: 12,
                ),
                Expanded(
                  child: Container(
                    height: 83.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('assets/images/mission_10.png', height: 80),
                        Image.asset(
                          'assets/images/mission_pro.png',
                          height: 80,
                        ),
                        Column(
                          spacing: 5.h,
                          children: [
                            Image.asset(
                              'assets/images/one_50.png',
                              width: 48.w,
                              height: 48.h,
                            ),
                            RichText(
                              text: TextSpan(
                                text: formatAmount(
                                  communityMission?.point ?? 0,
                                ),
                                style: TextStyles.smallBold12(context).copyWith(
                                  color: AppColors.primary,
                                  fontFamily: AppFonts.baloo2,
                                  height: 1.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: communityMission?.title ?? "",
              style: TextStyles.bodySemiBold16(
                context,
              ).copyWith(fontFamily: AppFonts.baloo2, height: 1.sp),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _TimeSection extends StatefulWidget {
  const _TimeSection();

  @override
  State<_TimeSection> createState() => _TimeSectionState();
}

class _TimeSectionState extends State<_TimeSection> with UIToolMixin {
  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityMissionBloc, CommunityMissionState>(
      builder: (context, state) {
        CommunityMission? communityMission = state.mission;
        final now = DateTime.now().toUtc();
        final differenceInSeconds =
            (communityMission?.endDate ?? DateTime.now())
                .toUtc()
                .difference(now)
                .inSeconds
                .clamp(0, double.infinity)
                .toInt();
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(width: 1.r, color: AppColors.black05),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  spacing: 10.h,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "TIME LEFT",
                        style: TextStyles.smallBold12(context, opacity: .24),
                      ),
                    ),
                    Countdown(
                      controller: _timerController,
                      seconds: differenceInSeconds,
                      build: (BuildContext context, double time) {
                        List<String> timeList = formattedTime2(time);
                        return Row(
                          spacing: 4.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            timeBox(context, timeList[0]),
                            timeColon(context),
                            timeBox(context, timeList[1]),
                            timeColon(context),
                            timeBox(context, timeList[2]),
                            timeColon(context),
                            timeBox(context, timeList[3]),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 23.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GradientProgress(
                            height: 23,
                            progress:
                                (communityMission?.usersJoined ?? 0) /
                                (communityMission?.maxUsers ?? 1),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Container(
                              height: 23.h,
                              width: double.infinity,
                              color: AppColors.grey200, // background
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      (communityMission?.usersJoined ?? 0) /
                                      5000,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFA259FF),
                                          Color(0xFFDEC4FF),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "${communityMission?.usersJoined ?? 0} / ${communityMission?.maxUsers ?? 0} users joined",
                              style: TextStyles.cardRegular10(
                                context,
                              ).copyWith(fontFamily: AppFonts.baloo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              if (state.hasJoined == MissionStatus.pending ||
                  differenceInSeconds == 0 ||
                  ((communityMission?.usersJoined ?? 0) >= 5000))
                IconTextButton(
                  onPressed: () {
                    showMessage(
                      state.hasJoined == MissionStatus.pending
                          ? "Mission Already Completed"
                          : differenceInSeconds == 0
                          ? "Mission Ended"
                          : "Mission Full",
                      context,
                      color: Colors.white,
                      styleColor: Colors.black,
                    );
                  },
                  height: 50,
                  color: AppColors.grey300.withValues(alpha: .85),
                  text: "Join this mission",
                  textColor: AppColors.white75,
                )
              else if (state.hasJoined == MissionStatus.completed)
                Image.asset("assets/images/mark.png")
              else
                IconTextButton(
                  onPressed: () {
                    communityEventDialog(communityMission: communityMission!);
                  },
                  height: 50,
                  color: AppColors.black,
                  textColor: AppColors.white,
                  text: "Join this mission",
                ),
            ],
          ),
        );
      },
    );
  }

  List<String> formattedTime2(double time) {
    final int days = (time / 86400).floor(); // 1 day = 86400 seconds
    final int hours = ((time % 86400) / 3600).floor();
    final int minutes = ((time % 3600) / 60).floor();
    final int seconds = (time % 60).floor();

    return [
      days.toString().padLeft(2, "0"),
      hours.toString().padLeft(2, "0"),
      minutes.toString().padLeft(2, "0"),
      seconds.toString().padLeft(2, "0"),
    ];
  }

  Widget timeBox(BuildContext context, String value) {
    return Container(
      width: 56.w,
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.black05,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: value,
          style: TextStyles.h1Bold38(context).copyWith(
            fontSize: 36.sp,
            height: 1.sp,
            fontFamily: AppFonts.baloo2,
            color: AppColors.black29,
          ),
        ),
      ),
    );
  }

  Widget timeColon(BuildContext context) {
    return RichText(
      text: TextSpan(text: ":", style: TextStyles.smallBold12(context)),
    );
  }
}
