import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/fonts.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:flowva/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../home/presentation/bloc/campaign_cubit.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import 'draw_end_page.dart';

class ReferCampaign extends StatefulWidget {
  ReferCampaign({super.key, this.transparent = false});

  final bool transparent;

  @override
  State<ReferCampaign> createState() => _ReferCampaignState();
}

class _ReferCampaignState extends State<ReferCampaign> {
  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );
  int differenceInSeconds = 0;

  List<CampaignModel> campaign = [];

  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit();
    campaign = homeCubit.state.campaign;

    if (campaign.isNotEmpty) {
      final now = DateTime.now().toUtc();
      differenceInSeconds = campaign.last.campaignEndDate
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
        campaign = state.campaign;

        if (campaign.isEmpty) return SizedBox.shrink();

        final now = DateTime.now().toUtc();
        differenceInSeconds = campaign.last.campaignEndDate
            .difference(now)
            .inSeconds
            .clamp(0, double.infinity)
            .toInt();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.transparent)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/giveaway_card.png",
                      fit: BoxFit.cover,
                    ),
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
                            text: campaign.last.name.toString(),
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
                              text: campaign.last.title.toString(),
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
                              child: Image.network(
                                campaign.last.url.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 90,

                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          // White container
                          Positioned(
                            bottom: 40, // lift the white box slightly
                            child: Container(
                              width: 290,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.80),
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
                          ),

                          // Button overlapping the white box bottom
                          Positioned(
                            bottom: 0,
                            child: GestureDetector(
                              //ReferralContestScreen() //DrawEndPage()
                              onTap: () {
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
                                      builder: (_) =>
                                          BlocProvider<CampaignCubit>(
                                            create: (_) => sl<CampaignCubit>(
                                              param1: campaign.last.id ?? 0,
                                            ),
                                            child: ReferralContestScreen(
                                              campaignEndDate:
                                                  campaign
                                                      .last
                                                      .campaignEndDate ??
                                                  DateTime.now(),
                                            ),
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 320,

                                child: Center(
                                  child: Text(
                                    'Join the draw',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2B2B2B),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
}
