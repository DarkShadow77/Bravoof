import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../home/presentation/bloc/campaign_cubit.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import 'draw_end_page.dart';
import 'price_details_dialog.dart';

class ReferCampaign extends StatefulWidget {
  ReferCampaign({
    super.key,
    this.transparent = false,
    this.showMargin = true,
    this.expanded = false,
  });

  final bool transparent;
  final bool showMargin;
  final bool expanded;

  @override
  State<ReferCampaign> createState() => _ReferCampaignState();
}

class _ReferCampaignState extends State<ReferCampaign> {
  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );
  int differenceInSeconds = 0;

  List<CampaignResponseModel> campaignList = [];
  CampaignResponseModel campaign = CampaignResponseModel.empty();

  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit();
    campaignList = homeCubit.state.campaign;

    if (campaignList.isNotEmpty) {
      final now = DateTime.now().toUtc();
      differenceInSeconds = campaign.campaignEndDate
          .difference(now)
          .inSeconds
          .clamp(0, double.infinity)
          .toInt();
    }
    homeCubit.fetchCampaigns();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        campaignList = state.campaign;

        if (campaignList.isEmpty) return SizedBox.shrink();

        campaign = campaignList.last;

        final now = DateTime.now().toUtc();
        differenceInSeconds = campaign.campaignEndDate
            .difference(now)
            .inSeconds
            .clamp(0, double.infinity)
            .toInt();

        return Container(
          margin: widget.showMargin
              ? EdgeInsets.symmetric(horizontal: 16.w)
              : null,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.transparent)
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/giveaway_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/oraimo.png"),
                        SizedBox(width: 8.w),
                        RichText(
                          text: TextSpan(
                            text: campaign.name.toString(),
                            style: TextStyles.smallBold12(context).copyWith(
                              color: widget.transparent
                                  ? null
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: campaign.title.toString(),
                              style: TextStyles.bigTitleBold24(context)
                                  .copyWith(
                                    fontSize: 22.sp,
                                    fontFamily: AppFonts.baloo2,
                                    height: 1.2.sp,
                                    color: !widget.transparent
                                        ? Color(0xFFDCB5FF)
                                        : Color(0xFFAB7A7A),
                                  ),
                            ),
                          ),
                        ),

                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.white05,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.white30,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: widget.transparent
                                  ? AppColors.redBrown20
                                  : Color(0xFFDEC4FF),
                              child: CachedImageSize(
                                imageUrl: campaign.url,
                                width: 45,
                                height: 45,
                                fit: BoxFit.contain,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.expanded) ...[
                      RichText(
                        text: TextSpan(
                          text:
                              'Invite 2 friends to qualify. All qualifiers entered in the draw gets 50 coins each.',
                          style: TextStyles.smallBold12(
                            context,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                      SizedBox(height: 5.h),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: widget.expanded ? null : AppColors.white80,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Countdown(
                            controller: _timerController,
                            seconds: differenceInSeconds,
                            build: (BuildContext context, double time) {
                              List<String> timeList = formattedTime2(time);
                              if (widget.expanded) {
                                return Row(
                                  spacing: 4.w,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _timerBox2(timeList[0], "DAYS"),
                                    timeColon(),
                                    _timerBox2(timeList[1], "HRS"),
                                    timeColon(),
                                    _timerBox2(timeList[2], "MIN"),
                                    timeColon(),
                                    _timerBox2(timeList[3], "SEC"),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ends in ',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF191919),
                                    ),
                                  ),
                                  _timerBox('${timeList[0]} days'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${timeList[1]}h'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${timeList[2]}m'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${timeList[3]}s'),
                                ],
                              );
                            },
                          ),
                        ),
                        IconTextButton(
                          height: 54,
                          onPressed: () {
                            if (differenceInSeconds == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => DrawEndPage(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider<CampaignCubit>(
                                    create: (_) =>
                                        sl<CampaignCubit>(param1: campaign.id),
                                    child: ReferralContestScreen(
                                      campaign: campaign,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          text: "Join the Draw",
                        ),
                      ],
                    ),
                    if (widget.expanded) ...[
                      IconTextButton(
                        height: 54,
                        onPressed: () => priceDetailsDialog(
                          campaignEndDate: campaign.campaignEndDate,
                        ),
                        text: "See Prize Details",
                        color: AppColors.white.withValues(alpha: .16),
                        textColor: AppColors.white,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 4.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white10,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            avatar("1"),
                            avatar("2"),
                            avatar("3"),
                            avatar("4"),
                            avatar("5"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white30,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 15.sp,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '+12',
                                      style: TextStyles.smallSemibold12(
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
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'Qualify by inviting 2 friends who sign up via your link.',
                          style: TextStyles.cardSemibold10(
                            context,
                          ).copyWith(color: AppColors.white50),
                        ),
                      ),
                    ],
                    // const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _timerBox(String text) {
    return Container(
      // margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }

  /// --- Helper Widgets
  Widget _timerBox2(String value, String label) {
    return Container(
      width: 55.w,
      height: 55.h,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white10,
        boxShadow: [
          BoxShadow(
            color: AppColors.black10,
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 10,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget timeColon() {
    return RichText(
      text: TextSpan(
        text: ":",
        style: TextStyles.bodyBold16(context).copyWith(color: AppColors.white),
      ),
    );
  }

  Widget avatar(String index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Image.asset("assets/avatar/$index.png", height: 24.h),
    );
  }
}
