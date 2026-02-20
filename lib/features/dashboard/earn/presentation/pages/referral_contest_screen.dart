import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/app/view/widgets/dialog/success_dialog.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/earn/presentation/pages/delivery_address_page.dart';
import 'package:bravoo/features/dashboard/home/presentation/bloc/campaign_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../home/data/model/campaign_response.dart';
import '../../../nav_bar.dart';
import '../../../profile/data/model/user_profile.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/price_details_dialog.dart';
import 'invite_earn.dart';

Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xff')));
}

class ReferralContestScreen extends StatefulWidget {
  const ReferralContestScreen({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  @override
  State<ReferralContestScreen> createState() => _ReferralContestScreenState();
}

class _ReferralContestScreenState extends State<ReferralContestScreen>
    with UIToolMixin {
  CampaignResponseModel campaign = CampaignResponseModel.empty();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    campaign = widget.campaign;
    super.initState();

    log("Date Time ${campaign.campaignEndDate}");
    context.read<CampaignBloc>().add(LoadTotalCampaignParticipants());
    context.read<CampaignBloc>().add(LoadUserReferralsForCampaign());
    context.read<CampaignBloc>().add(IsUserInCampaign());
    context.read<CampaignBloc>().add(HasUserClaimedReward());
  }

  _loadingState(BuildContext context, CampaignLoadingState state) {
    if (state.type == CampaignType.claimReward) {
      outerLoadingDialog(text: "Claiming Reward");
    }
  }

  _successState(BuildContext context, CampaignSuccessState state) {
    if (state.type == CampaignType.claimReward) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(GetProfileEvent());
      successDialog(
        title: "You Gave It a Shot!",
        subTitle: state.message,
        mainBtnText: "Done",
        mainBtnPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BottomNavBar(index: 0, missionIndex: 0),
            ),
            (route) => false,
          );
        },
      );
    }
  }

  _failureState(BuildContext context, CampaignFailureState state) {
    if (state.type == CampaignType.claimReward) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasEnded = campaign.campaignEndDate.isBefore(DateTime.now());
    final isWinner = campaign.winnerUserId == supabase.auth.currentUser!.id;
    final color = hasEnded
        ? isWinner
              ? hexToColor(campaign.bgColor)
              : hexToColor(campaign.endBgColor)
        : hexToColor(campaign.bgColor);

    final textColor = hexToColor(campaign.textColor);
    return BlocListener<CampaignBloc, CampaignState>(
      listener: (context, state) {
        if (state is CampaignLoadingState) {
          _loadingState(context, state);
        }
        if (state is CampaignSuccessState) {
          _successState(context, state);
        }
        if (state is CampaignFailureState) {
          _failureState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: color,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, size: 16.sp, color: textColor),
          ),
          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: hasEnded
                  ? isWinner
                        ? "Congratulations! You Won 🎉"
                        : "Better Luck Next Time!"
                  : campaign.innerTitle,
              style: TextStyles.bigTitleRegular24(context).copyWith(
                fontFamily: AppFonts.baloo,
                height: 1.sp,
                color: textColor,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 16.sp,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Stack(
            children: [
              if (!hasEnded || (hasEnded && isWinner))
                Image.asset(
                  AssetsPngImages.campaignBg,
                  fit: BoxFit.cover,
                  height: 440.h + MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  color: textColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height:
                        12.h +
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top,
                  ),

                  Flexible(
                    child: Stack(
                      children: [
                        /*Positioned(
                          left: 0,
                          right: 0,
                          top: 115.h,
                          child: Image.asset(
                            AssetsPngImages.podium,
                            width: 104.w,
                            height: 148.h,
                            fit: BoxFit.contain,
                          ),
                        ),*/
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 115.h,
                          child: podiumBlock(
                            color: hexToColor(campaign.bgColor),
                            height: 148.h,
                          ),
                        ),

                        if (hasEnded && isWinner)
                          Positioned(
                            left: 100.w,
                            right: 0.w,
                            top: 55.h,
                            child: Image.asset(
                              AssetsPngImages.one50,
                              width: 72.w,
                              height: 72.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 15.h,
                          child: CachedImageSize(
                            imageUrl: campaign.url,
                            width: 142.w,
                            height: 110.h,
                            color: Colors.transparent,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (hasEnded) ...[
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 150.h,
                            child: Container(
                              height: 130.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    textColor.withValues(alpha: .15),
                                    textColor.withValues(alpha: .35),
                                    textColor.withValues(alpha: .55),
                                    color.withValues(alpha: .5),
                                    color,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          /*Positioned(
                            left: 0,
                            right: 0,
                            top: 150.h,
                            child: Image.asset(
                              AssetsPngImages.campaignEndBg,
                              height: 130.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),*/
                          if (isWinner) ...[
                            Positioned(
                              left: 70.w,
                              top: 30.h,
                              child: CachedImageRadius(
                                imageUrl: campaign.winnerProfileImage,
                                size: 94,
                                circle: true,
                                fit: BoxFit.cover,
                                color: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 70.h,
                              child: Image.asset(
                                AssetsPngImages.campaignWinner,
                                width: 200.w,
                                height: 116.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ] else
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 100.h,
                              child: Image.asset(
                                AssetsPngImages.campaignEnd,
                                width: 228.w,
                                height: 82.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                        Container(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.only(
                            top: 194.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 1.w,
                              color: textColor.withValues(alpha: .01),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (hasEnded)
                                HasEndedWidget(
                                  campaign: campaign,
                                  isWinner: isWinner,
                                ),
                              TimerWidget(
                                campaign: campaign,
                                campaignEndDate: campaign.campaignEndDate,
                                hasEnded: hasEnded,
                                isWinner: isWinner,
                              ),
                              Container(
                                color: textColor.withValues(alpha: .08),
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 44.h),
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
                                        text: "CONTEST RULES",
                                        style: TextStyles.bodyRegular16(context)
                                            .copyWith(
                                              fontFamily: AppFonts.baloo,
                                              color: textColor,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: campaign.instructions.length,
                                      itemBuilder: (context, index) {
                                        final instruction =
                                            campaign.instructions[index];
                                        return RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: instruction,
                                            style:
                                                TextStyles.smallSemibold12(
                                                  context,
                                                ).copyWith(
                                                  color: textColor.withValues(
                                                    alpha: .7,
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    ReferralContainer(campaign: campaign),
                                  ],
                                ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget podiumBlock({
    bool isFull = true,
    required double height,
    required Color color,
  }) {
    final bgColor = hexToColor(campaign.bgColor);

    final textColor = hexToColor(campaign.textColor);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Front face (main block)
        Container(
          width: 108.w,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                bgColor,
                bgColor.withValues(alpha: .45),
                textColor.withValues(alpha: .1),
              ],
              stops: [0.3, .5, 1],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(5.r),
            ),
          ),
        ),

        // Top face (angled using Transform)
        Positioned(
          top: 0,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.skewX(-0.4), // Skew to create 3D angle
            child: Container(
              width: isFull ? 103.11.w : 92.w,
              height: 20.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 3.3,
                  colors: [
                    AppColors.black.withValues(alpha: .05),
                    textColor.withValues(alpha: .1),
                    textColor.withValues(alpha: .3),
                    textColor.withValues(
                      alpha: .5,
                    ), // Light edge (white shadow)
                  ],
                  stops: [0.3, 0.4, 0.7, .8],
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HasEndedWidget extends StatefulWidget {
  const HasEndedWidget({
    super.key,
    required this.campaign,
    required this.isWinner,
  });

  final bool isWinner;
  final CampaignResponseModel campaign;
  @override
  State<HasEndedWidget> createState() => _HasEndedWidgetState();
}

class _HasEndedWidgetState extends State<HasEndedWidget> with UIToolMixin {
  @override
  Widget build(BuildContext context) {
    final textColor = hexToColor(widget.campaign.textColor);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        spacing: 16.h,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.campaign.winnerUserId.isNotEmpty) ...[
            if (!widget.isWinner)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "The ${widget.campaign.item} goes to "),
                    TextSpan(
                      text: "@${widget.campaign.winnerName}",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text:
                          " You didn’t win this time, but the next one could be yours.",
                    ),
                  ],
                  style: TextStyles.smallBold12(
                    context,
                  ).copyWith(color: textColor.withValues(alpha: .65)),
                ),
              )
            else
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "The ${widget.campaign.item} has won this time! Claim are yours. Claim your reward now to enter your information and receive your gift.",
                  style: TextStyles.smallBold12(
                    context,
                  ).copyWith(color: textColor.withValues(alpha: .80)),
                ),
              ),
            BlocBuilder<CampaignBloc, CampaignState>(
              builder: (context, state) {
                if (!state.isUserInCampaign) return Container();
                return IconTextButton(
                  height: 52,
                  color: state.hasClaimed
                      ? AppColors.grey300
                      : Color(0xff642020),
                  textColor: AppColors.white,
                  borderColor: state.hasClaimed
                      ? AppColors.white50
                      : AppColors.white,
                  onPressed: () {
                    if (!state.hasClaimed) {
                      if (widget.isWinner) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider<CampaignBloc>(
                              create: (_) =>
                                  sl<CampaignBloc>(param1: widget.campaign.id),
                              child: DeliveryAddressScreen(
                                campaign: widget.campaign,
                              ),
                            ),
                          ),
                        );
                      } else {
                        context.read<CampaignBloc>().add(
                          ClaimParticipantReward(),
                        );
                      }
                    } else {
                      showMessage(
                        "Reward Already Claimed",
                        context,
                        color: Colors.green,
                        styleColor: Colors.black,
                      );
                    }
                  },
                  text: widget.isWinner ? "Claim Reward" : "Collect Your Coin",
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.hasEnded,
    required this.isWinner,
    required this.campaignEndDate,
    required this.campaign,
  });

  final bool hasEnded;
  final bool isWinner;
  final DateTime campaignEndDate;
  final CampaignResponseModel campaign;

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
    WinnerDialog();
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
    final textColor = hexToColor(widget.campaign.textColor);
    return Container(
      height: 156.h,
      width: double.infinity,

      child: Stack(
        children: [
          if (!widget.hasEnded || (widget.hasEnded && widget.isWinner))
            Image.asset(
              AssetsPngImages.productTimerBg1,
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
                    ).copyWith(color: textColor.withValues(alpha: .32)),
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
                            campaign: widget.campaign,
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
                            ).copyWith(color: textColor),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            campaign: widget.campaign,
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
                            ).copyWith(color: textColor),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            campaign: widget.campaign,
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
                            ).copyWith(color: textColor),
                          ),
                        ),
                        Expanded(
                          child: CountdownBox(
                            campaign: widget.campaign,
                            count: timeList[3],
                            subTitle: "Secs",
                          ),
                        ),
                      ],
                    );
                  },
                  onFinished: () {},
                ),
                Expanded(
                  child: InnerShadowContainer(
                    offset: Offset(0, 4),
                    blur: 6.r,
                    borderRadius: 100.r,
                    backgroundColor: textColor.withValues(alpha: .16),
                    shadowColor: AppColors.black.withValues(alpha: .04),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: BlocBuilder<CampaignBloc, CampaignState>(
                          builder: (context, state) {
                            return RichText(
                              text: TextSpan(
                                text:
                                    "${state.totalParticipants} users have entered so far",
                                style: TextStyles.smallRegular12(context)
                                    .copyWith(
                                      fontFamily: AppFonts.baloo,
                                      color: textColor,
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
  const CountdownBox({
    super.key,
    required this.count,
    required this.subTitle,
    required this.campaign,
  });

  final String count;
  final String subTitle;
  final CampaignResponseModel campaign;

  @override
  Widget build(BuildContext context) {
    final textColor = hexToColor(campaign.textColor);
    return Container(
      height: 67.h,
      width: 67.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(width: 1.w, color: textColor.withValues(alpha: .04)),
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
                  ).copyWith(color: textColor.withValues(alpha: .48)),
                ),
              ],
              style: TextStyles.h2Bold32(context).copyWith(
                height: 1.h,
                fontFamily: AppFonts.baloo2,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralContainer extends StatefulWidget {
  const ReferralContainer({super.key, required this.campaign});

  final CampaignResponseModel campaign;

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

  String referralMessage(String code, [bool encode = true]) {
    if (encode) {
      return Uri.encodeComponent(
        'Join me on Bravoo 🚀\n'
        'https://www.joinbravoo.com\n'
        'Use my referral code: $code\n',
      );
    } else {
      return 'Join me on Bravoo 🚀\n'
          'https://www.joinbravoo.com\n'
          'Use my referral code: $code\n';
    }
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
      SharePlus.instance.share(ShareParams(text: referralMessage(code, false)));
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
      SharePlus.instance.share(ShareParams(text: referralMessage(code, false)));
    }
  }

  Future<void> shareToLinkedIn(String code) async {
    final text = referralMessage(code);

    final linkedInUrl =
        'https://www.linkedin.com/sharing/share-offsite/?url=$text';

    final uri = Uri.parse(linkedInUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SharePlus.instance.share(ShareParams(text: referralMessage(code, false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayCount = referredUsers.length > 5 ? 5 : referredUsers.length;

    return BlocBuilder<CampaignBloc, CampaignState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => referredUsers = state.referrals);
        });

        final textColor = hexToColor(widget.campaign.textColor);
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
            margin: EdgeInsets.symmetric(vertical: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: .2),
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
                    textColor: textColor,
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
                    onPressed: () =>
                        priceDetailsDialog(campaign: widget.campaign),
                    text: "See Prize Details",
                    color: textColor.withValues(alpha: .16),
                    textColor: textColor,
                  ),
                ],

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
                        color: textColor.withValues(alpha: .05),
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
                                  imageUrl: user.profilePic,
                                  size: 24.r,
                                  circle: true,
                                  color: textColor.withValues(alpha: .1),
                                ),
                                if (index != displayCount - 1)
                                  Container(
                                    width: 1.w,
                                    height: 18.h,
                                    color: textColor.withValues(alpha: .05),
                                  ),
                              ],
                            );
                          }),
                          if (referredUsers.length < 2) ...[
                            if (referredUsers.length > 0)
                              Container(
                                width: 1.w,
                                height: 18.h,
                                color: textColor.withValues(alpha: .05),
                              ),
                            SvgPicture.asset(
                              AssetsSvgIcons.user,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                          if (referredUsers.length > 5) ...[
                            Container(
                              width: 1.w,
                              height: 18.h,
                              color: textColor.withValues(alpha: .05),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: .08),
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
                                    colorFilter: ColorFilter.mode(
                                      textColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "${referredUsers.length - 5}",
                                      style: TextStyles.smallSemibold12(
                                        context,
                                      ).copyWith(color: textColor),
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
                    ).copyWith(color: textColor.withValues(alpha: .3)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Divider(
                    height: 1.h,
                    color: textColor.withValues(alpha: .08),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Invite your friends quick & easy.",
                    style: TextStyles.normalSemibold14(
                      context,
                    ).copyWith(color: textColor.withValues(alpha: .64)),
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
                            color: textColor.withValues(alpha: .08),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '${userProfile.referralCode}',
                                    style: TextStyles.smallSemibold12(
                                      context,
                                    ).copyWith(color: textColor),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                AssetsSvgIcons.copy,
                                width: 16.w,
                                height: 16.h,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  textColor,
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
                        campaign: widget.campaign,
                        icon: AssetsPngImages.whatsapp,
                        subTitle: "Whatsapp",
                        onTap: () => shareToWhatsApp(userProfile.referralCode),
                      ),
                    ),
                    Expanded(
                      child: SocialBox(
                        campaign: widget.campaign,
                        icon: AssetsPngImages.x,
                        subTitle: "X(Twitter)",
                        onTap: () => shareToX(userProfile.referralCode),
                      ),
                    ),
                    Expanded(
                      child: SocialBox(
                        campaign: widget.campaign,
                        icon: AssetsPngImages.linkedIn,
                        subTitle: "LinkedIn",
                        onTap: () => shareToLinkedIn(userProfile.referralCode),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Divider(
                    height: 1.h,
                    color: textColor.withValues(alpha: .08),
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
                              ).copyWith(color: textColor),
                            ),
                          ),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16.sp,
                            color: textColor,
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
                          colorFilter: ColorFilter.mode(
                            textColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${referredUsers.length}",
                            style: TextStyles.bodySemiBold16(
                              context,
                            ).copyWith(color: textColor),
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
    required this.campaign,
  });

  final String icon;
  final String subTitle;
  final VoidCallback onTap;
  final CampaignResponseModel campaign;

  @override
  Widget build(BuildContext context) {
    final textColor = hexToColor(campaign.textColor);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 86.3.h,
        width: 86.3.w,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: .24),
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
                ).copyWith(color: textColor.withValues(alpha: .64)),
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
          child: Container(color: AppColors.black25),
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
                          color: AppColors.black20,
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
