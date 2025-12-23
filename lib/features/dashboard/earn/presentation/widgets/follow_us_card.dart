import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/app/view/widgets/cached_image_widget.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/constants/fonts.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../bloc/social_mission_bloc.dart';
import '../../data/models/social_mission_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white80,
        borderRadius: BorderRadius.circular(16.r),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              RichText(
                text: TextSpan(
                  text: 'Follow Us On Socials 🔥',
                  style: TextStyles.titleBold20(
                    context,
                  ).copyWith(fontFamily: AppFonts.baloo2),
                ),
              ),
              SizedBox(height: 16.h),

              // Progress bar area with markers and icons
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Container(
                  height: 8.h,
                  width: double.infinity,
                  color: Color(0xFFF1F1F1), // background
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: safeProgress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFA259FF), Color(0xFFDEC4FF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "0%",
                        style: TextStyles.smallCardSemibold8(
                          context,
                          opacity: .35,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "33%",
                        style: TextStyles.smallCardSemibold8(
                          context,
                          opacity: .55,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "67%",
                        style: TextStyles.smallCardSemibold8(
                          context,
                          opacity: .75,
                        ),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "100%",
                      style: TextStyles.smallCardSemibold8(context),
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
    // container with rounded corners and subtle background
    return GestureDetector(
      onTap: () {
        if (!(missionStatus == MissionStatus.completed ||
            missionStatus == MissionStatus.pending)) {
          socialEventDialog(socialMission: socialMission);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color:
              (missionStatus == MissionStatus.completed ||
                  missionStatus == MissionStatus.pending)
              ? Color(0xFFECD6FF)
              : Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(16.r),
        ),

        child: Column(
          spacing: 7.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageRadius(
              imageUrl: socialMission.image,
              size: 32,
              circle: true,
              fit: BoxFit.cover,
            ),
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: socialMission.title,
                style: TextStyles.cardBold10(context),
              ),
            ),
            (missionStatus == MissionStatus.completed ||
                    missionStatus == MissionStatus.pending)
                ? Image.asset(
                    AssetsPngImages.check,
                    width: 14.r,
                    height: 14.r,
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(
                    AssetsSvgIcons.circleLock,
                    width: 14.r,
                    height: 14.r,
                    fit: BoxFit.contain,
                  ),
          ],
        ),
      ),
    );
  }
}
