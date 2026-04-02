import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/date_time_helper.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../bloc/squad_bloc.dart';
import '../widget/join_squad_dialog.dart';
import '../widget/leave_squad_dialog.dart';

class SquadDetailsPage extends StatefulWidget {
  const SquadDetailsPage({super.key, required this.squad});

  final Squad squad;

  @override
  State<SquadDetailsPage> createState() => _SquadDetailsPageState();
}

class _SquadDetailsPageState extends State<SquadDetailsPage> with UIToolMixin {
  late Squad squad;

  @override
  void initState() {
    squad = widget.squad;
    super.initState();
    context.read<SquadBloc>().add(FetchSquadsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SquadBloc, SquadState>(
      builder: (context, state) {
        squad = state.squads.firstWhere((e) => e.id == squad.id);
        final textColor = hexToColor(squad.textColor);
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/earn_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
              CustomScrollView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    centerTitle: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.black05,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowLeft02,
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Join Squad",
                              style: TextStyles.titleSemiBold20(context),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0,
                          child: CircleAvatar(
                            backgroundColor: AppColors.black05,
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowLeft02,
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 116.w,
                              height: 98.h,
                              decoration: BoxDecoration(
                                color: AppColors.white80,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  width: 3.w,
                                  color: AppColors.white,
                                ),
                              ),
                              child: Center(
                                child: CachedImageRadius(
                                  imageUrl: squad.image,
                                  circle: true,
                                  size: 80,
                                  fit: BoxFit.cover,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "${squad.name.capitalize} Squad",
                            style: TextStyles.titleSemiBold20(context).copyWith(
                              height: 1.h,
                              fontFamily: AppFonts.baloo2,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          spacing: 2.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedCalendar03,
                              size: 16.sp,
                              color: AppColors.grey500,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text:
                                    "Created ${formatSmartDate(squad.createdAt.toIso8601String(), showTime: false)}",
                                style: TextStyles.cardBold10(
                                  context,
                                ).copyWith(color: AppColors.grey500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: squad.about.isEmpty
                                ? "No Description"
                                : squad.about,
                            style: TextStyles.smallMedium12(
                              context,
                              opacity: .75,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 19.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.white,
                                hexToColor(squad.gradientColor.end),
                                hexToColor(squad.gradientColor.start),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            spacing: 16.h,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                spacing: 7.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildSquadDetailContainer(
                                      context,
                                      title: "Squad",
                                      value: "${squad.name.capitalize} Squad",
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildSquadDetailContainer(
                                      context,
                                      title: "Who can play?",
                                      value: "Squad members",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 7.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildSquadDetailContainer(
                                      context,
                                      title: "Reward",
                                      value: "Yes",
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildSquadDetailContainer(
                                      context,
                                      title: "How many can join?",
                                      value: "${squad.maxUsers} people",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        IconTextButton(
                          onPressed: () {
                            if (squad.isFull) {
                              showMessage(
                                "${squad.name.capitalize} Squad is Full",
                                context,
                                status: true,
                              );
                            } else if (squad.cooldownDaysRemaining > 1) {
                              showMessage(
                                "Please wait ${squad.cooldownDaysRemaining} more day(s) before joining",
                                context,
                                status: true,
                              );
                            } else if (squad.canJoin) {
                              joinSquadDialog(squad: squad);
                            } else if (squad.isJoined) {
                              leaveSquadDialog(squad: squad);
                            }
                          },
                          text: squad.isFull
                              ? "Full"
                              : squad.isJoined
                              ? "Leave ${squad.name.capitalize} Squad"
                              : "Join ${squad.name.capitalize} Squad",
                          textColor: AppColors.white,
                          color: squad.isJoined
                              ? AppColors.error
                              : squad.isFull
                              ? AppColors.grey550
                              : textColor,
                        ),
                        SizedBox(height: 23.h),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                "Members ${squad.usersJoined}/${squad.maxUsers}",
                            style: TextStyles.normalSemibold14(context)
                                .copyWith(
                                  fontFamily: AppFonts.baloo2,
                                  height: 1.h,
                                ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ]),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (squad.members.isEmpty)
                        SizedBox(
                          height: 80.h,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: "No Members Yet",
                                style: TextStyles.smallSemibold12(
                                  context,
                                  opacity: .65,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 80.h,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: squad.members.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final member = squad.members[index];
                              return SizedBox(
                                width: 60.w,
                                child: Column(
                                  spacing: 4.h,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedImageRadius(
                                      imageUrl: member.profileImage,
                                      size: 60,
                                      fit: BoxFit.cover,
                                      circle: true,
                                      color: AppColors.grey200,
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "${member.name.capitalize}",
                                        style: TextStyles.smallBold12(context)
                                            .copyWith(
                                              fontFamily: AppFonts.baloo2,
                                              height: 1.h,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (_, _) => SizedBox(width: 8.w),
                          ),
                        ),
                    ]),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 20.h),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "${squad.name.capitalize} Squad  Missions",
                            style: TextStyles.normalSemibold14(context),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: 20.h + MediaQuery.of(context).viewPadding.top,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSquadDetailContainer(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            text: TextSpan(
              text: title,
              style: TextStyles.smallRegular12(context),
            ),
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            text: TextSpan(
              text: value,
              style: TextStyles.bodySemiBold16(
                context,
              ).copyWith(fontFamily: AppFonts.baloo2, height: 1.h),
            ),
          ),
        ],
      ),
    );
  }
}
