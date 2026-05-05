import 'dart:math';

import 'package:bravoo/app/view/widgets/gradient_progress.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/brand_model.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
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
import '../../data/model/response/brand_mission_model.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_individual_bloc.dart';

class BrandDetailsPage extends StatefulWidget {
  const BrandDetailsPage({super.key, required this.brand});

  final Brand brand;

  @override
  State<BrandDetailsPage> createState() => _BrandDetailsPageState();
}

class _BrandDetailsPageState extends State<BrandDetailsPage> with UIToolMixin {
  late Brand brand;

  Color textColor = AppColors.error;
  Color inverseTextColor = AppColors.black;
  Color endColor = Colors.transparent;
  Color startColor = Colors.transparent;

  @override
  void initState() {
    brand = widget.brand;
    super.initState();
    context.read<BrandBloc>().add(FetchBrandsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandIndividualBloc>(
      create: (_) => sl<BrandIndividualBloc>(param1: brand.id),
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, brandState) {
          brand = brandState.brands.firstWhere((e) => e.id == brand.id);
          textColor = hexToColor(brand.textColor);
          inverseTextColor = hexToColor(brand.inverseTextColor);

          endColor = hexToColor(brand.gradientColor.end);
          startColor = hexToColor(brand.gradientColor.start);
          return Scaffold(
            backgroundColor: hexToColor(brand.gradientColor.end),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/earn_bg.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          hexToColor(brand.gradientColor.end),
                          hexToColor(brand.gradientColor.end),
                          hexToColor(brand.gradientColor.start),
                          hexToColor(brand.gradientColor.start),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                CustomScrollView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      backgroundColor: hexToColor(brand.gradientColor.start),
                      automaticallyImplyLeading: false,
                      pinned: true,
                      centerTitle: false,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: textColor.withValues(alpha: .05),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowLeft02,
                                color: textColor,
                                strokeWidth: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: brand.name.capitalize,
                                style: TextStyles.titleSemiBold20(
                                  context,
                                ).copyWith(color: textColor),
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
                              LiquidGlassLayer(
                                settings: LiquidGlassSettings(
                                  lightAngle: 0.3 * pi,
                                  ambientStrength: .8,
                                  glassColor: textColor.withValues(alpha: .05),
                                  thickness: 60,
                                ),
                                child: LiquidGlass(
                                  shape: LiquidRoundedSuperellipse(
                                    borderRadius: 1000.r,
                                  ),
                                  child: Container(
                                    width: 98.w,
                                    height: 98.h,
                                    clipBehavior: Clip.antiAlias,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hexToColor(brand.logoBgColor),
                                      ),
                                      child: Center(
                                        child: CachedImageRadius(
                                          imageUrl: brand.logo,
                                          circle: true,
                                          size: 60,
                                          fit: BoxFit.cover,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            spacing: 2.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar03,
                                size: 16.sp,
                                color: textColor.withValues(alpha: .65),
                              ),
                              RichText(
                                text: TextSpan(
                                  text:
                                      "Created ${formatSmartDate(brand.createdAt.toIso8601String(), showTime: false)}",
                                  style: TextStyles.cardBold10(context)
                                      .copyWith(
                                        color: textColor.withValues(alpha: .65),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: brand.about.isEmpty
                                  ? "No Description"
                                  : brand.about,
                              style: TextStyles.smallMedium12(context).copyWith(
                                color: textColor.withValues(alpha: .75),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          LiquidGlassLayer(
                            settings: LiquidGlassSettings(
                              lightAngle: 0.2 * pi,
                              ambientStrength: .5,
                            ),
                            child: LiquidGlass(
                              shape: LiquidRoundedSuperellipse(
                                borderRadius: 18.r,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 19.h,
                                  horizontal: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  color: textColor.withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: Column(
                                  spacing: 16.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      spacing: 7.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _buildBrandDetailContainer(
                                            context,
                                            title: "Brand",
                                            value: "${brand.name.capitalize}",
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildBrandDetailContainer(
                                            context,
                                            title: "Who can play?",
                                            value: "Followers",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 7.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _buildBrandDetailContainer(
                                            context,
                                            title: "Reward",
                                            value: "Yes",
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildBrandDetailContainer(
                                            context,
                                            title: "How many can join?",
                                            value: "∞",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          /*IconTextButton(
                            onPressed: () {
                              if (brand.isFull) {
                                showMessage(
                                  "${brand.name.capitalize} Brand is Full",
                                  context,
                                  status: true,
                                );
                              } else if (brand.cooldownDaysRemaining > 1) {
                                showMessage(
                                  "Please wait ${brand.cooldownDaysRemaining} more day(s) before joining",
                                  context,
                                  status: true,
                                );
                              } else if (brand.canJoin) {
                                joinBrandDialog(squad: brand);
                              } else if (brand.isJoined) {
                                leaveBrandDialog(squad: brand);
                              }
                            },
                            text: brand.isFull
                                ? "Full"
                                : brand.isJoined
                                ? "Leave ${brand.name.capitalize} Brand"
                                : "Join ${brand.name.capitalize} Brand",
                            textColor: AppColors.white,
                            color: brand.isJoined
                                ? AppColors.error
                                : brand.isFull
                                ? AppColors.grey550
                                : textColor,
                          ),*/
                          SizedBox(height: 23.h),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text:
                                  "Followers (${formatAmount(brand.followerCount)})",
                              style: TextStyles.normalSemibold14(context)
                                  .copyWith(
                                    color: textColor,
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
                        if (brand.followers.isEmpty)
                          SizedBox(
                            height: 80.h,
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "No Followers Yet",
                                  style:
                                      TextStyles.smallSemibold12(
                                        context,
                                        opacity: .65,
                                      ).copyWith(
                                        color: textColor.withValues(alpha: .65),
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
                              itemCount: brand.followers.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final follower = brand.followers[index];
                                return SizedBox(
                                  width: 60.w,
                                  child: Column(
                                    spacing: 4.h,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedImageRadius(
                                        imageUrl: follower.profileImage,
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
                                          text: "${follower.name.capitalize}",
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
                              text: "${brand.name.capitalize} Missions",
                              style: TextStyles.normalSemibold14(
                                context,
                              ).copyWith(color: textColor),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    BlocBuilder<BrandIndividualBloc, BrandIndividualState>(
                      builder: (context, state) {
                        final brandMission = state.missions;
                        bool isLoading =
                            state is BrandIndividualLoadingState &&
                            state.type == BrandIndividualType.fetch;
                        return BrandMissionCard(
                          brand: brand,
                          isLoading: isLoading,
                          brandMissions: brandMission,
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

  Widget _buildBrandDetailContainer(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return LiquidGlassLayer(
      settings: LiquidGlassSettings(lightAngle: 10, ambientStrength: .3),
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: 6.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: .75),
            borderRadius: BorderRadius.circular(12.r),
          ),
          clipBehavior: Clip.antiAlias,
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
                  style: TextStyles.smallRegular12(
                    context,
                  ).copyWith(color: inverseTextColor),
                ),
              ),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: value,
                  style: TextStyles.bodySemiBold16(context).copyWith(
                    fontFamily: AppFonts.baloo2,
                    height: 1.h,
                    color: inverseTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandMissionCard extends StatelessWidget {
  const BrandMissionCard({
    super.key,
    required this.isLoading,
    required this.brandMissions,
    required this.brand,
  });

  final bool isLoading;
  final List<BrandMission> brandMissions;
  final Brand brand;

  @override
  Widget build(BuildContext context) {
    if (isLoading && brandMissions.isEmpty)
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
                    height: 145.h,
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
    else if (brandMissions.isEmpty)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: 100.h,
            child: Center(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "No Brand Missions",
                  style: TextStyles.smallSemibold12(context).copyWith(
                    color: hexToColor(brand.textColor).withValues(alpha: .65),
                  ),
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
          itemCount: brandMissions.length,
          itemBuilder: (context, index) {
            final brandMission = brandMissions[index];
            final double progress = brandMission.maxUsers == 0
                ? 0.0
                : brandMission.usersJoined / brandMission.maxUsers;
            final double safeProgress = progress.clamp(0.0, 1.0);
            return GestureDetector(
              /*onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      // Pass the EXISTING instance — don't create a new one
                      BlocProvider.value(
                        value: context.read<BrandIndividualBloc>(),
                      ),
                      // Create a NEW scoped BrandMissionBloc for this page
                      BlocProvider<BrandMissionBloc>(
                        create: (_) => sl<BrandMissionBloc>(
                          param1: brand.id,
                          param2: brandMission.id,
                        ),
                      ),
                    ],
                    child: BrandMissionDetailsPage(
                      squad: brand,
                      squadMission: brandMission,
                    ),
                  ),
                ),
              ),*/
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
                      imageUrl: brandMission.image,
                      width: double.infinity,
                      height: 145.h,
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
                                          "${formatAmount(brandMission.points)}",
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
                                text: "${brandMission.timeLeft}",
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
                              "${brandMission.usersJoined}/${brandMission.maxUsers} joined",
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
                                text: brandMission.title,
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
                                text: brandMission.subtitle,
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
                                    text: brandMission.isJoined
                                        ? "Leave Mission"
                                        : brandMission.actionLabel,
                                    onPressed: () {} /* => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                          providers: [
                                            // Pass the EXISTING instance — don't create a new one
                                            BlocProvider.value(
                                              value: context
                                                  .read<BrandIndividualBloc>(),
                                            ),
                                            // Create a NEW scoped BrandMissionBloc for this page
                                            BlocProvider<BrandMissionBloc>(
                                              create: (_) =>
                                                  sl<BrandMissionBloc>(
                                                    param1: brand.id,
                                                    param2: brandMission.id,
                                                  ),
                                            ),
                                          ],
                                          child: BrandMissionDetailsPage(
                                            squad: brand,
                                            squadMission: brandMission,
                                          ),
                                        ),
                                      ),
                                    )*/,
                                    paddingH: 0,
                                    paddingW: 0,
                                    textSize: 8,
                                    textColor: AppColors.white,
                                    color: _primaryButtonColor(brandMission),
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

  Color _primaryButtonColor(BrandMission mission) {
    if (mission.isJoined) return AppColors.error;
    if (mission.hasExpired || mission.isFull) return AppColors.grey550;
    return AppColors.black;
  }
}
