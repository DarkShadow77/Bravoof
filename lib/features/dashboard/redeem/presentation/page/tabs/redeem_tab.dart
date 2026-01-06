import 'dart:async';

import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/app/view/widgets/button/icon_text_button.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/constants/app_colors.dart';
import 'package:flowva/core/constants/fonts.dart';
import 'package:flowva/core/utils/helpers.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/jackpot_page.dart';
import 'package:flowva/features/dashboard/redeem/presentation/bloc/redeem_bloc.dart';
import 'package:flowva/features/dashboard/redeem/presentation/widget/redeem_gift_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../../utility/ui_tool_mix.dart';
import '../../../../../onbaording/data/model/user_profile.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../widget/redeem_learn_more_modal.dart';

class RedeemTab extends StatefulWidget {
  RedeemTab({this.campaign, super.key});
  final Campaign? campaign;
  @override
  State<RedeemTab> createState() => _RedeemTabState();
}

class _RedeemTabState extends State<RedeemTab>
    with SingleTickerProviderStateMixin, UIToolMixin {
  // late TabController _tabController;
  final _pageController = PageController(initialPage: 0);
  double _pageHeight = 300;
  int _currentPage = 0;
  Timer? _timer;
  Duration? _remainingTime;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = Duration(
      days: widget.campaign!.campaignEndDate!.day,
      hours: widget.campaign!.campaignEndDate!.hour,
      minutes: widget.campaign!.campaignEndDate!.minute,
      seconds: widget.campaign!.campaignEndDate!.second,
    );
    _startCountdown();
  }

  void _startCountdown() {
    // Calculate initial remaining time
    _updateRemainingTime();

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final difference = widget.campaign!.campaignEndDate!.difference(now);

    if (difference.isNegative) {
      setState(() {
        _isExpired = true;
        _remainingTime = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _remainingTime = difference;
        _isExpired = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _tabController.dispose();
    super.dispose();
  }

  _loadingState(BuildContext context, RedeemLoadingState state) {
    if (state.type == RedeemType.redeemAirtimeData ||
        state.type == RedeemType.redeemGiftcard) {
      outerLoadingDialog(text: "Redeeming");
    }
  }

  _successState(BuildContext context, RedeemSuccessState state) async {
    if (state.type == RedeemType.redeemAirtimeData) {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.isBottomSheetOpen ?? false) Get.back();
      context.read<ProfileBloc>().add(GetProfileEvent());
      context.read<RedeemBloc>().add(LoadRedeemHistory());
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
      );
    } else if (state.type == RedeemType.redeemGiftcard) {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.isBottomSheetOpen ?? false) Get.back();

      context.read<ProfileBloc>().add(GetProfileEvent());

      final uri = Uri.tryParse(state.message);

      if (uri == null) {
        showMessage(
          "Invalid gift card URL",
          context,
          color: Colors.white,
          styleColor: Colors.black,
          iconColor: Colors.red,
          status: true,
        );
      } else
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  _failureState(BuildContext context, RedeemFailureState state) {
    if (state.type == RedeemType.redeemAirtimeData ||
        state.type == RedeemType.redeemGiftcard) {
      if (Get.isDialogOpen ?? false) Get.back();
      context.read<ProfileBloc>().add(GetProfileEvent());
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
    final days = _remainingTime!.inDays;
    final hours = _remainingTime!.inHours.remainder(24);
    final minutes = _remainingTime!.inMinutes.remainder(60);
    final seconds = _remainingTime!.inSeconds.remainder(60);

    return SingleChildScrollView(
      child: Column(
        // shrinkWrap: true,
        // padding: EdgeInsets.only(top: 16),
        // physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          // 🎁 Giveaway Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/oraimo.png"),
                      SizedBox(width: 8),
                      Text(
                        'Oraimo OpenSnap Contest',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 250,
                          child: Text(
                            'Refer to win Oraimo OpenSnap Airpod!',
                            style: GoogleFonts.baloo2(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFAB7A7A),
                            ),
                          ),
                        ),
                      ),

                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(
                            0xFFFF8687,
                          ).withValues(alpha: 0.19),
                          child: Image.asset(
                            "assets/images/ear_pod.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // SvgPicture.asset("assets/images/ear_pod.svg",height: 40,),
                    ],
                  ),
                  Container(
                    height: 100,

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
                            decoration: const BoxDecoration(
                              color: Colors.white,
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
                            child: Row(
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
                                _timerBox('$days days'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${hours}h'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${minutes}m'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${seconds}s'),
                              ],
                            ),
                          ),
                        ),

                        // Button overlapping the white box bottom
                        Positioned(
                          bottom: -20,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 330,
                            clipBehavior: Clip.hardEdge,
                            child: FlowvaButton.noneOutlineBlackButton(
                              name: "Refer your friends",
                              fontSize: 16,
                              apply: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => InviteAndEarnPage(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 💡 Info Box
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                spacing: 8.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.black, size: 18.sp),
                  Expanded(
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Keep engaging to unlock more rewards',
                            style: TextStyles.normalBold14(context),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              text: 'Refer more users to get more spin',
                              style: TextStyles.smallSemibold12(context)
                                  .copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpTo(0);
                        print(_pageHeight);
                      },
                      child: Text(
                        'JACKPOT & GIVEAWAYS',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  _currentPage == 0
                      ? Container(
                          height: 2,
                          width: 165,
                          color: Color(0xFF9013FE),
                        )
                      : Container(),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(1);
                        print(_pageHeight);
                      },
                      child: Text(
                        'GIFTS & VIRTUAL CARDS',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  _currentPage == 1
                      ? Container(
                          height: 2,
                          width: 165,
                          color: Color(0xFF9013FE),
                        )
                      : Container(),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 💰 Jackpot Cards
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _pageHeight,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: PageView(
              controller: _pageController,
              // physics: ClampingScrollPhysics(),
              onPageChanged: (index) {
                print(index);
                setState(() {
                  _currentPage = index;
                  // 👇 set different heights for different pages
                  _pageHeight = index == 0
                      ? 300.h
                      : MediaQuery.of(context).size.height * 0.7;
                });
              },
              children: [
                // First tab placeholder
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    UserProfile profile = state.profile;
                    return _rewardCard(
                      icon: Icons.savings,
                      title: 'Bravoo Jackpot 🏆',
                      subtitle: SizedBox(
                        width: 255,
                        child: RichText(
                          // textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Your chance to win',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2B2B2B),
                                ),
                              ),
                              TextSpan(
                                text: ' 20,000 coins',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF9013FE),
                                ),
                              ),
                              TextSpan(
                                text:
                                    '  is here. Invite your friends and let the adventure begin!',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2B2B2B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      cost: '100 Coins',
                      tag: 'Hot',
                      tagColor: Color(0xFFFE5613),
                      buttonText: 'Enter Jackpot',
                      active: (profile.spins ?? 0) > 0,
                    );
                  },
                ),

                // Second tab: Gifts & Virtual Cards
                BlocListener<RedeemBloc, RedeemState>(
                  listener: (context, state) {
                    if (state is RedeemLoadingState) {
                      _loadingState(context, state);
                    }
                    if (state is RedeemSuccessState) {
                      _successState(context, state);
                    }
                    if (state is RedeemFailureState) {
                      _failureState(context, state);
                    }
                  },
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      UserProfile profile = state.profile;
                      return GridView.custom(
                        childrenDelegate: SliverChildListDelegate([
                          /*buildRewardCard(
                      title: "Paypal",
                      imagePath: "assets/images/slant_visa.png",
                      coins: "20,000 Coins",
                      isActive: true,
                    ),*/
                          buildRewardCard(
                            title: "Airtime",
                            value: 5,
                            imagePath: AssetsPngImages.cash,
                            coins: 5000,
                            isActive: (profile.totalPoints ?? 0) >= 5000,
                          ),
                          buildRewardCard(
                            title: "Data",
                            value: 5,
                            imagePath: AssetsPngImages.data,
                            coins: 5000,
                            isActive: (profile.totalPoints ?? 0) >= 5000,
                            isHot: true,
                          ),
                          buildRewardCard(
                            title: "Giftcard",
                            value: 10,
                            imagePath: AssetsPngImages.giftcard,
                            coins: 10000,
                            isActive: (profile.totalPoints ?? 0) >= 10000,
                            isHot: true,
                          ),
                        ]),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          mainAxisExtent: 255.h,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildRewardCard({
    required String title,
    required String imagePath,
    required int coins,
    required int value,
    required bool isActive,
    bool isHot = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.white85,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.5.r, color: AppColors.white50),
        boxShadow: [
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(1, 2),
          ),
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .09),
            blurRadius: 10,
            offset: const Offset(3, 9),
          ),
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .05),
            blurRadius: 13,
            offset: const Offset(8, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Column(
              spacing: 12.h,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔥 Hot badge + Image
                Image.asset(
                  imagePath,
                  height: 56.h,
                  width: 56.w,
                  fit: BoxFit.contain,
                ),
                RichText(
                  text: TextSpan(
                    text: "\$${value} $title",
                    style: TextStyles.bodyBold16(
                      context,
                    ).copyWith(fontFamily: AppFonts.baloo2, height: 1.sp),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary05,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/one_50.png",
                        height: 12.h,
                        width: 12.w,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${formatAmount(coins, compact: true)} Coins',
                          style: TextStyles.cardBold10(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                IconTextButton(
                  onPressed: () {
                    if (isActive)
                      redeemGiftModal(
                        showPhone: ["Airtime", "Data"].contains(title),
                        onPressed: (val) {
                          final profile = context
                              .read<ProfileBloc>()
                              .state
                              .profile;
                          if (["Airtime", "Data"].contains(title)) {
                            if (val != null) {
                              context.read<RedeemBloc>().add(
                                RedeemAirtimeData(
                                  rewardType: title.toLowerCase(),
                                  phone: val,
                                  userName: profile.name ?? "",
                                  email: profile.email ?? "",
                                  coins: coins,
                                ),
                              );
                            }
                          } else {
                            context.read<RedeemBloc>().add(
                              RedeemGiftcard(
                                rewardType: title.toLowerCase(),
                                phone: "",
                                userName: profile.name ?? "",
                                email: profile.email ?? "",
                                coins: coins,
                              ),
                            );
                          }
                        },
                      );
                    else
                      showMessage(
                        "You don't have Sufficient Coins",
                        context,
                        color: Colors.white,
                        styleColor: Colors.black,
                        iconColor: Colors.red,
                        status: true,
                      );
                  },
                  height: 34,
                  color: isActive ? AppColors.black : AppColors.grey400,
                  textSize: 10,
                  borderColor: Colors.transparent,
                  textColor: isActive ? AppColors.white : AppColors.white60,
                  text: "Claim now",
                ),
                Divider(color: AppColors.black05, height: 1.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      redeemLearnMoreModal(image: imagePath);
                    },
                    child: Row(
                      spacing: 6.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: 16.sp,
                          color: AppColors.grey500,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Learn more",
                            style: TextStyles.smallSemibold12(
                              context,
                            ).copyWith(color: AppColors.grey500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isHot)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.orange11,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  spacing: 2.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetsPngImages.flame,
                      width: 16.w,
                      height: 16.h,
                      fit: BoxFit.contain,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Hot",
                        style: TextStyles.cardBold10(
                          context,
                        ).copyWith(color: AppColors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _rewardCard({
    required IconData icon,
    required String title,
    required Widget subtitle,
    required String cost,
    required String buttonText,
    required bool active,
    String? tag,
    Color? tagColor,
  }) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            spreadRadius: -3,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (tag != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor?.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFFE5613),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          tag,
                          style: TextStyle(
                            color: tagColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Image.asset("assets/images/flying_coins.png"),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            subtitle,
            active
                ? FlowvaButton.jackpotButton(
                    name: "Play the Jackot",
                    color: Colors.white,
                    apply: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => JackpotScreen()),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FlowvaButton.noneOutlineBlackButton(
                      name: "Invite your friends",
                      apply: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => InviteAndEarnPage(),
                        ),
                      ),
                    ),
                  ),
            Text(
              "Invite 10+ friends every month to unluck the jackpot",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF767676),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerBox(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }
}
