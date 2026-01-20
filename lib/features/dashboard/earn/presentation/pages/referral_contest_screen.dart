import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../onbaording/data/model/user_profile.dart';
import '../../../home/presentation/bloc/campaign_cubit.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/price_details_dialog.dart';
import 'invite_earn.dart';

class ReferralContestScreen extends StatefulWidget {
  const ReferralContestScreen({super.key, required this.campaignEndDate});

  final DateTime campaignEndDate;

  @override
  State<ReferralContestScreen> createState() => _ReferralContestScreenState();
}

class _ReferralContestScreenState extends State<ReferralContestScreen> {
  @override
  void initState() {
    super.initState();

    log("Date Time ${widget.campaignEndDate}");
    BlocProvider.of<CampaignCubit>(context).getTotalCampaignParticipants();
    BlocProvider.of<CampaignCubit>(context).getUserReferralsForCampaign();
    BlocProvider.of<CampaignCubit>(context).isUserInCampaign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 16.sp,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Image.asset(
              AssetsPngImages.homeBg,
              fit: BoxFit.cover,
              height: 440.h + MediaQuery.of(context).padding.top,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12.h + MediaQuery.of(context).padding.top),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Enter to win the Oraimo\nOpenSnap!",
                      style: TextStyles.bigTitleRegular24(context).copyWith(
                        fontFamily: AppFonts.baloo,
                        height: 1.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 115.h,
                          child: Image.asset(
                            AssetsPngImages.podium,
                            width: 104.w,
                            height: 148.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsPngImages.product,
                              width: 152.w,
                              height: 130.h,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.only(top: 194.h),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 1.w,
                              color: AppColors.white.withValues(alpha: .01),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TimerWidget(
                                campaignEndDate: widget.campaignEndDate,
                              ),
                              SizedBox(height: 24.h),
                              Image.asset(
                                AssetsPngImages.speaker,
                                width: 36.5.w,
                                height: 40.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 14.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "QUALIFICATION RULE",
                                  style: TextStyles.bodyRegular16(context)
                                      .copyWith(
                                        fontFamily: AppFonts.baloo,
                                        color: AppColors.white,
                                      ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      "Invite at least 2 friends who sign up\nthrough your link to qualify.",
                                  style: TextStyles.smallSemibold12(context)
                                      .copyWith(
                                        color: AppColors.white.withValues(
                                          alpha: .7,
                                        ),
                                      ),
                                ),
                              ),
                              ReferralContainer(
                                campaignEndDate: widget.campaignEndDate,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h + MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.campaignEndDate});

  final DateTime campaignEndDate;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );
  int differenceInSeconds = 0;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now().toUtc();
    differenceInSeconds = widget.campaignEndDate
        .difference(now)
        .inSeconds
        .clamp(0, double.infinity)
        .toInt();
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
    return Container(
      height: 156.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.purple,
        border: Border.all(
          width: 1.w,
          color: AppColors.white.withValues(alpha: .04),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3.r,
            color: Color(0xffAAA7A7).withValues(alpha: .1),
          ),
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 5.r,
            color: Color(0xffAAA7A7).withValues(alpha: .09),
          ),
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 7.r,
            color: Color(0xffAAA7A7).withValues(alpha: .05),
          ),
          BoxShadow(
            offset: Offset(0, 21),
            blurRadius: 8.r,
            color: Color(0xffAAA7A7).withValues(alpha: .01),
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.asset(
            AssetsPngImages.productTimerBg,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              spacing: 10.h,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "DRAW ENDS IN",
                    style: TextStyles.smallBold12(
                      context,
                    ).copyWith(color: AppColors.white.withValues(alpha: .32)),
                  ),
                ),
                Countdown(
                  controller: _timerController,
                  seconds: differenceInSeconds,
                  build: (BuildContext context, double time) {
                    List<String> timeList = formattedTime2(time);
                    return Row(
                      spacing: 4.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CountdownBox(
                            count: timeList[0],
                            subTitle: "Days",
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: ":",
                            style: TextStyles.bodyBold16(
                              context,
                            ).copyWith(color: AppColors.white),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            count: timeList[1],
                            subTitle: "Hours",
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: ":",
                            style: TextStyles.bodyBold16(
                              context,
                            ).copyWith(color: AppColors.white),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            count: timeList[2],
                            subTitle: "Mins",
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: ":",
                            style: TextStyles.bodyBold16(
                              context,
                            ).copyWith(color: AppColors.white),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            count: timeList[3],
                            subTitle: "Secs",
                          ),
                        ),
                      ],
                    );
                  },
                  onFinished: () {
                    setState(() {
                      _timerController.restart();
                    });
                  },
                ),
                Expanded(
                  child: InnerShadowContainer(
                    offset: Offset(0, 4),
                    blur: 6.r,
                    borderRadius: 100.r,
                    backgroundColor: AppColors.white.withValues(alpha: .16),
                    shadowColor: AppColors.black.withValues(alpha: .04),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: BlocBuilder<CampaignCubit, CampaignState>(
                          builder: (context, state) {
                            return RichText(
                              text: TextSpan(
                                text:
                                    "${state.totalParticipants} users have entered so far",
                                style: TextStyles.smallRegular12(context)
                                    .copyWith(
                                      fontFamily: AppFonts.baloo,
                                      color: AppColors.white,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownBox extends StatelessWidget {
  const CountdownBox({super.key, required this.count, required this.subTitle});

  final String count;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67.h,
      width: 67.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          width: 1.w,
          color: AppColors.white.withValues(alpha: .04),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "$count\n",
              children: [
                TextSpan(
                  text: subTitle,
                  style: TextStyles.smallSemibold12(
                    context,
                  ).copyWith(color: AppColors.white.withValues(alpha: .48)),
                ),
              ],
              style: TextStyles.h2Bold32(context).copyWith(
                height: 1.h,
                fontFamily: AppFonts.baloo2,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralContainer extends StatefulWidget {
  const ReferralContainer({super.key, required this.campaignEndDate});

  final DateTime campaignEndDate;

  @override
  State<ReferralContainer> createState() => _ReferralContainerState();
}

class _ReferralContainerState extends State<ReferralContainer> {
  List<UserProfile> referredUsers = [];

  UserProfile userProfile = UserProfile.empty();

  List<UserProfile> referrals = [];
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetProfileEvent());
    userProfile = profileBloc.state.profile;
  }

  String referralMessage(String code) {
    return Uri.encodeComponent(
      'Join me on Bravoo 🚀\n'
      'Use my referral link:\n'
      'https://app.joinbravoo.com?ref=$code',
    );
  }

  Future<void> shareToWhatsApp(String code) async {
    final text = referralMessage(code);

    final whatsappUrl = Platform.isIOS
        ? 'whatsapp://send?text=$text'
        : 'https://wa.me/?text=$text';

    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SharePlus.instance.share(ShareParams(text: text));
    }
  }

  Future<void> shareToX(String code) async {
    final text = referralMessage(code);

    final xUrl = Platform.isIOS
        ? 'twitter://post?message=$text'
        : 'https://twitter.com/intent/tweet?text=$text';

    final uri = Uri.parse(xUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SharePlus.instance.share(ShareParams(text: text));
    }
  }

  Future<void> shareToLinkedIn(String code) async {
    final link = Uri.encodeComponent('https://app.joinbravoo.com?ref=$code');

    final linkedInUrl =
        'https://www.linkedin.com/sharing/share-offsite/?url=$link';

    await launchUrl(
      Uri.parse(linkedInUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayCount = referredUsers.length > 5 ? 5 : referredUsers.length;
    return BlocBuilder<CampaignCubit, CampaignState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => referredUsers = state.referrals);
        });

        return MultiBlocProvider(
          providers: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                setState(() {
                  userProfile = state.profile;
                });
              },
            ),
          ],
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                width: 1.5.w,
                color: AppColors.black.withValues(alpha: .04),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 4.r,
                  color: Color(0xffAAA7A7).withValues(alpha: .1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state.isUserInCampaign)
                  IconTextButton(
                    onPressed: () {},
                    text: "You've Entered",
                    icon: AssetsSvgIcons.checkmark,
                    color: AppColors.green500,
                    textColor: AppColors.white,
                  )
                else ...[
                  IconTextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => InviteAndEarnPage(),
                        ),
                      );
                    },
                    text: "Invite Friends Now",
                    icon: AssetsSvgIcons.userAdd,
                  ),
                  IconTextButton(
                    onPressed: () => priceDetailsDialog(
                      campaignEndDate: widget.campaignEndDate,
                    ),

                    text: "See Prize Details",
                    color: AppColors.white.withValues(alpha: .16),
                    textColor: AppColors.white,
                  ),
                ],

                // FlowvaButton.greenButton(
                //         color: Colors.white,
                //         // buttonColor: Color(0xFF008753),
                //         icon: Icon(
                //           Icons.check_circle,
                //           color: Colors.white,
                //         ),
                //         name: "Invite Friends Now",
                //         apply: () {
                //           setState(() {
                //             onClick = false;
                //           });
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) =>
                //         DeliveryAddressScreen(),
                //   ),
                // );
                // },
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        spacing: 8.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(displayCount, (index) {
                            final user = referredUsers[index];
                            return Row(
                              spacing: 8.w,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedImageRadius(
                                  imageUrl: user.profilePic ?? "",
                                  size: 24.r,
                                  circle: true,
                                  color: AppColors.white10,
                                ),
                                if (index != displayCount - 1)
                                  Container(
                                    width: 1.w,
                                    height: 18.h,
                                    color: AppColors.white.withValues(
                                      alpha: .05,
                                    ),
                                  ),
                              ],
                            );
                          }),
                          if (referredUsers.length < 2) ...[
                            if (referredUsers.length > 0)
                              Container(
                                width: 1.w,
                                height: 18.h,
                                color: AppColors.white.withValues(alpha: .05),
                              ),
                            SvgPicture.asset(
                              AssetsSvgIcons.user,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ],
                          if (referredUsers.length > 5) ...[
                            Container(
                              width: 1.w,
                              height: 18.h,
                              color: AppColors.white.withValues(alpha: .05),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                spacing: 4.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetsSvgIcons.userMultiple,
                                    width: 14.w,
                                    height: 14.h,
                                    fit: BoxFit.contain,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "${referredUsers.length - 5}",
                                      style: TextStyles.smallSemibold12(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: referredUsers.isEmpty
                        ? "Invite Friends to participate in this campaign."
                        : referredUsers.length == 1
                        ? "Once your second friend joins, you’re\nautomatically entered."
                        : "Your entry is confirmed for this draw.",
                    style: TextStyles.smallSemibold12(
                      context,
                    ).copyWith(color: AppColors.white30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Divider(
                    height: 1.h,
                    color: AppColors.white.withValues(alpha: .08),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Invite your friends quick & easy.",
                    style: TextStyles.normalSemibold14(
                      context,
                    ).copyWith(color: AppColors.white.withValues(alpha: .64)),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: '${userProfile.referralCode}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Referral code copied to clipboard!',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 8.r,
                                color: Color(0xffA259FF).withValues(alpha: .1),
                              ),
                            ],
                          ),
                          child: Row(
                            spacing: 10.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        'https://app.joinbravoo.com?ref=${userProfile.referralCode}',
                                    style: TextStyles.smallSemibold12(
                                      context,
                                    ).copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                AssetsSvgIcons.copy,
                                width: 16.w,
                                height: 16.h,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  spacing: 10.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SocialBox(
                        icon: AssetsPngImages.whatsapp,
                        subTitle: "Whatsapp",
                        onTap: () => shareToWhatsApp(userProfile.referralCode!),
                      ),
                    ),
                    Expanded(
                      child: SocialBox(
                        icon: AssetsPngImages.x,
                        subTitle: "X(Twitter)",
                        onTap: () => shareToX(userProfile.referralCode!),
                      ),
                    ),
                    Expanded(
                      child: SocialBox(
                        icon: AssetsPngImages.linkedIn,
                        subTitle: "LinkedIn",
                        onTap: () => shareToLinkedIn(userProfile.referralCode!),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Divider(
                    height: 1.h,
                    color: AppColors.white.withValues(alpha: .08),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 4.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "You referred",
                              style: TextStyles.smallSemibold12(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16.sp,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 4.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AssetsSvgIcons.userMultiple,
                          width: 16.w,
                          height: 16.h,
                          fit: BoxFit.contain,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${referredUsers.length}",
                            style: TextStyles.bodySemiBold16(
                              context,
                            ).copyWith(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SocialBox extends StatelessWidget {
  const SocialBox({
    super.key,
    required this.icon,
    required this.subTitle,
    required this.onTap,
  });

  final String icon;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 86.3.h,
        width: 86.3.w,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .24),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          spacing: 10.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon, height: 32.h, width: 32.w, fit: BoxFit.contain),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: subTitle,
                style: TextStyles.cardSemibold10(
                  context,
                ).copyWith(color: AppColors.white.withValues(alpha: .64)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerDialog extends StatelessWidget {
  const WinnerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 36,
                    width: 36,
                    margin: EdgeInsets.only(left: 40, top: 30, bottom: 30),

                    decoration: BoxDecoration(
                      // color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),

                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [
                          Color(0xFFFAD961), // light yellow
                          Colors.white, // white middle
                          Color(0xFFFAD961), // light yellow again
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'You did it James!',
                    style: GoogleFonts.baloo2(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "You’re this Month’s winner",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset("assets/images/winner_package.png"),
                SizedBox(height: 20),
                FlowvaButton.winnerButton(name: "Claim Reward"),
                SizedBox(height: 20),
                Text(
                  "Your consistency, curiosity, and Flowva spirit just paid off. Enjoy your Oraimo Boomsnap + 500 FlowCoins!",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
