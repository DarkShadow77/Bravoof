import 'package:bravoo/app/view/widgets/gradient_progress.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_mission_model.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/date_time_helper.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../earn/presentation/pages/invite_earn.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/squad_bloc.dart';
import '../bloc/squad_individual_bloc.dart';
import '../bloc/squad_mission_bloc.dart';
import '../widget/join_squad_dialog.dart';
import '../widget/leave_squad_dialog.dart';
import 'squad_mission_details_page.dart';

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
    return BlocProvider<SquadIndividualBloc>(
      create: (_) => sl<SquadIndividualBloc>(param1: squad.id),
      child: BlocBuilder<SquadBloc, SquadState>(
        builder: (context, squadState) {
          squad = squadState.squads.firstWhere((e) => e.id == squad.id);
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              style: TextStyles.titleSemiBold20(context)
                                  .copyWith(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                    BlocBuilder<SquadIndividualBloc, SquadIndividualState>(
                      builder: (context, state) {
                        final squadMissions = state.missions;
                        bool isLoading =
                            state is SquadIndividualLoadingState &&
                            state.type == SquadIndividualType.fetch;
                        return SquadMissionCard(
                          squad: squad,
                          isLoading: isLoading,
                          squadMissions: squadMissions,
                        );
                      },
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.top,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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

class SquadMissionCard extends StatelessWidget {
  const SquadMissionCard({
    super.key,
    required this.isLoading,
    required this.squadMissions,
    required this.squad,
  });

  final bool isLoading;
  final List<SquadMission> squadMissions;
  final Squad squad;

  @override
  Widget build(BuildContext context) {
    if (isLoading && squadMissions.isEmpty)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        sliver: SliverGrid.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeShimmer(
                    width: double.infinity,
                    height: 153.h,
                    baseColor: AppColors.darkPrimary05,
                    highlightColor: AppColors.grey300.withValues(alpha: .25),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeShimmer(
                            width: 40.w,
                            height: 6.h,
                            radius: 12.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          FadeShimmer(
                            width: double.infinity,
                            height: 14.h,
                            radius: 12.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          FadeShimmer(
                            width: 50.w,
                            height: 14.h,
                            radius: 12.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          FadeShimmer(
                            width: double.infinity,
                            height: 8.h,
                            radius: 12.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          FadeShimmer(
                            width: double.infinity,
                            height: 8.h,
                            radius: 12.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            spacing: 10.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FadeShimmer(
                                  width: double.infinity,
                                  height: 20.h,
                                  radius: 12.r,
                                  baseColor: AppColors.darkPrimary05,
                                  highlightColor: AppColors.grey300.withValues(
                                    alpha: .25,
                                  ),
                                ),
                              ),
                              FadeShimmer(
                                width: 25.r,
                                height: 25.r,
                                radius: 1000.r,
                                baseColor: AppColors.darkPrimary05,
                                highlightColor: AppColors.grey300.withValues(
                                  alpha: .25,
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
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 280.h,
            crossAxisSpacing: 23.w,
            mainAxisSpacing: 24.h,
          ),
        ),
      );
    else if (squadMissions.isEmpty)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: 100.h,
            child: Center(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "No Squad Missions",
                  style: TextStyles.smallSemibold12(context, opacity: .65),
                ),
              ),
            ),
          ),
        ),
      );
    else
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        sliver: SliverGrid.builder(
          itemCount: squadMissions.length,
          itemBuilder: (context, index) {
            final squadMission = squadMissions[index];
            final double progress = squadMission.maxUsers == 0
                ? 0.0
                : squadMission.usersJoined / squadMission.maxUsers;
            final double safeProgress = progress.clamp(0.0, 1.0);
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      // Pass the EXISTING instance — don't create a new one
                      BlocProvider.value(
                        value: context.read<SquadIndividualBloc>(),
                      ),
                      // Create a NEW scoped SquadMissionBloc for this page
                      BlocProvider<SquadMissionBloc>(
                        create: (_) => sl<SquadMissionBloc>(
                          param1: squad.id,
                          param2: squadMission.id,
                        ),
                      ),
                    ],
                    child: SquadMissionDetailsPage(
                      squad: squad,
                      squadMission: squadMission,
                    ),
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CachedImageSize(
                      imageUrl: squadMission.image,
                      width: double.infinity,
                      height: 153.h,
                      color: AppColors.grey300.withValues(alpha: .25),
                      fit: BoxFit.cover,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppColors.black25,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 6.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 2.h,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary20,
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: AppColors.primary,
                                ),
                              ),
                              child: Row(
                                spacing: 4.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AssetsPngImages.one50,
                                    height: 12.r,
                                    width: 12.r,
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text:
                                          "${formatAmount(squadMission.points)}",
                                      style: TextStyles.cardBold10(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "${squadMission.timeLeft}",
                                style: TextStyles.smallCardSemibold8(context)
                                    .copyWith(
                                      fontFamily: AppFonts.baloo2,
                                      height: 1.h,
                                      color: AppColors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GradientProgress(
                      height: 6.h,
                      progress: safeProgress,
                      radius: 0,
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              "${squadMission.usersJoined}/${squadMission.maxUsers} joined",
                          style: TextStyles.smallCardRegular8(
                            context,
                            opacity: .65,
                          ).copyWith(fontFamily: AppFonts.baloo2, height: 1.h),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          spacing: 6.h,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: squadMission.title,
                                style: TextStyles.smallBold12(context).copyWith(
                                  fontSize: 13.sp,
                                  fontFamily: AppFonts.baloo2,
                                  height: 1.h,
                                ),
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: squadMission.subtitle,
                                style: TextStyles.cardRegular10(context)
                                    .copyWith(
                                      fontSize: 11.sp,
                                      fontFamily: AppFonts.baloo2,
                                      height: 1.h,
                                    ),
                              ),
                            ),
                            Row(
                              spacing: 10.w,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: IconTextButton(
                                    height: 22.h,
                                    text: "Join Mission",
                                    onPressed: () {},
                                    paddingH: 0,
                                    paddingW: 0,
                                    textSize: 8,
                                    textColor: AppColors.white,
                                    color: AppColors.black,
                                  ),
                                ),
                                BlocBuilder<ProfileBloc, ProfileState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () => SharePlus.instance.share(
                                        ShareParams(
                                          text: referralMessage(
                                            state.profile.referralCode,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        width: 25.r,
                                        height: 25.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 7.94.r,
                                              color: AppColors.black10,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: HugeIcon(
                                            icon:
                                                HugeIcons.strokeRoundedShare08,
                                            size: 12.sp,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 280.h,
            crossAxisSpacing: 23.w,
            mainAxisSpacing: 24.h,
          ),
        ),
      );
  }
}
