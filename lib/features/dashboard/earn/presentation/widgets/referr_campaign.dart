import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../home/presentation/bloc/campaign_bloc.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
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

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
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

        final textColor = hexToColor(campaign.textColor);
        final inverseTextColor = hexToColor(campaign.inverseTextColor);

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
              if (!widget.transparent) ...[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: hexToColor(campaign.bgColor),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Image.asset(
                    AssetsPngImages.campaignBg1,
                    fit: BoxFit.cover,
                    color: textColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ],
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedImageRadius(
                          imageUrl: campaign.brandImage,
                          size: 25,
                          circle: true,
                          color: Colors.transparent,
                          fit: BoxFit.cover,
                        ),
                        RichText(
                          text: TextSpan(
                            text: campaign.name.toString(),
                            style: TextStyles.smallBold12(context).copyWith(
                              color: widget.transparent ? null : textColor,
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
                                        ? hexToColor(campaign.cardTextColor)
                                        : Color(0xFFAB7A7A),
                                  ),
                            ),
                          ),
                        ),

                        CircleAvatar(
                          radius: 45,
                          backgroundColor: textColor.withValues(alpha: .05),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: textColor.withValues(alpha: .30),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: widget.transparent
                                  ? AppColors.redBrown20
                                  : hexToColor(campaign.cardTextColor),
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
                          ).copyWith(color: textColor),
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
                            color: widget.expanded
                                ? null
                                : textColor.withValues(alpha: .8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: inverseTextColor.withValues(alpha: .12),
                                blurRadius: 6.r,
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
                                  RichText(
                                    text: TextSpan(
                                      text: 'Ends in ',
                                      style: TextStyles.normalBold14(context)
                                          .copyWith(
                                            color: inverseTextColor,
                                            fontSize: 13.sp,
                                          ),
                                    ),
                                  ),
                                  _timerBox('${timeList[0]} days'),
                                  Icon(
                                    Icons.more_vert,
                                    size: 14.sp,
                                    color: inverseTextColor,
                                  ),
                                  _timerBox('${timeList[1]}h'),
                                  Icon(
                                    Icons.more_vert,
                                    size: 14.sp,
                                    color: inverseTextColor,
                                  ),
                                  _timerBox('${timeList[2]}m'),
                                  Icon(
                                    Icons.more_vert,
                                    size: 14.sp,
                                    color: inverseTextColor,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<CampaignBloc>(
                                  create: (_) =>
                                      sl<CampaignBloc>(param1: campaign.id),
                                  child: ReferralContestScreen(
                                    campaign: campaign,
                                  ),
                                ),
                              ),
                            );
                          },
                          color: textColor,
                          textColor: inverseTextColor,
                          text: differenceInSeconds <= 0
                              ? "Draw Ended (See Winner)"
                              : "Join the Draw",
                        ),
                      ],
                    ),
                    if (widget.expanded) ...[
                      IconTextButton(
                        height: 54,
                        onPressed: () => priceDetailsDialog(campaign: campaign),
                        text: "See Prize Details",
                        color: textColor.withValues(alpha: .16),
                        textColor: textColor,
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
                          color: textColor.withValues(alpha: .1),
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
                                color: textColor.withValues(alpha: .3),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.group,
                                    color: textColor,
                                    size: 15.sp,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '+12',
                                      style: TextStyles.smallSemibold12(
                                        context,
                                      ).copyWith(color: textColor),
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
                          ).copyWith(color: textColor.withValues(alpha: .5)),
                        ),
                      ),
                    ],
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
    final textColor = hexToColor(campaign.textColor);
    final inverseTextColor = hexToColor(campaign.inverseTextColor);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyles.smallSemibold12(
            context,
          ).copyWith(color: inverseTextColor),
        ),
      ),
    );
  }

  /// --- Helper Widgets
  Widget _timerBox2(String value, String label) {
    final textColor = hexToColor(campaign.textColor);
    final inverseTextColor = hexToColor(campaign.inverseTextColor);
    return Container(
      width: 55.w,
      height: 55.h,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: textColor.withValues(alpha: .1),
        boxShadow: [
          BoxShadow(
            color: inverseTextColor.withValues(alpha: .1),
            offset: const Offset(0, 4),
            blurRadius: 15.r,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyles.bigTitleBold24(context).copyWith(
                color: textColor,
                height: 1.0,
                fontFamily: AppFonts.baloo2,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyles.cardRegular10(
                context,
              ).copyWith(color: textColor.withValues(alpha: .7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeColon() {
    final textColor = hexToColor(campaign.textColor);
    return RichText(
      text: TextSpan(
        text: ":",
        style: TextStyles.bodyBold16(context).copyWith(color: textColor),
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
