import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_colors.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/badge_page.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flowva/features/mission/data/model/streak_response.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import 'leaderboard_widget.dart';

class EarnOverviewScreen extends StatefulWidget {
  const EarnOverviewScreen({super.key});

  @override
  State<EarnOverviewScreen> createState() => _EarnOverviewScreenState();
}

class _EarnOverviewScreenState extends State<EarnOverviewScreen>
    with UIToolMixin {
  late MissionCubit missionCubit;
  late UserCubit userCubit;
  UserProfile userProfile = UserProfile();
  final List<String> days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  final List<String> quotes = [
    "Rest, reset, then rise again.",
    "Consistency is louder than motivation.",
    "Tiny wins make tomorrow lighter.",
    "Showed up today? That's progress.",
    "Momentum feels good, doesn't it?",
    "Progress loves consistency.",
  ];
  List<RewardsSummary> rewardsSummary = [];

  @override
  void initState() {
    // TODO: implement initState
    userCubit = UserCubit();
    missionCubit = MissionCubit();
    userCubit.fetchUserProfile();
    missionCubit.fetchStreak();
    missionCubit.fetchAllUsersReward();
    super.initState();
  }

  bool init = true;
  StreakResponse streaks = StreakResponse();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MissionCubit, MissionState>(
          bloc: missionCubit,
          listener: (context, state) {
            print(state);
            if (state is StreakLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (_) => Center(
                  child: Container(
                    height: 400,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color(0xff828282),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF9013FE),
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
              );
            }
            if (state is StreakLoaded) {
              streaks = state.streakResponse;
            }
            if (state is RewardLoaded) {
              rewardsSummary = state.rewardsSummaryResponse.rewardsSummary!;

              setState(() {});
            }
            if (state is CheckedIn) {
              streaks = state.streakResponse;
              print("Streak ${streaks.currentStreak}");
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (_) => CustomSuccess(
                  title: "Awesome! ✨",
                  bodyText: quotes[streaks.currentStreak ?? 0],
                  b_text1: "Done",
                ),
              );
              setState(() {});
            }
            if (state is MissionFailed) {
              setState(() {
                init = false;
              });
            }
            if (state is CheckInFailed) {
              Navigator.pop(context);
              showMessage(
                state.err,
                context,
                color: Colors.white,
                styleColor: Colors.black,
                iconColor: Colors.red,
                status: true,
              );
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          bloc: userCubit,
          listener: (context, state) {
            if (state is UserProfileSuccess) {
              setState(() {
                init = false;
              });
              setState(() {
                userProfile = state.userProfile;
              });
              print(userProfile.toJson());
            }
          },
        ),
      ],
      child: init
          ? Center(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  backgroundColor: Color(0xff828282),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9013FE)),
                  strokeCap: StrokeCap.round,
                ),
              ),
            )
          : ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              children: [
                // Flowva Points Earned Card
                _pointsCard(),

                const SizedBox(height: 20),

                // Missions Card
                _missionCard(),

                const SizedBox(height: 20),

                // Streak Section
                _streakCard(
                  apply: () {
                    missionCubit.claimStreakToday();
                  },
                ),

                const SizedBox(height: 20),

                // Badges Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Badges",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => BadgesScreen()),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Color(0xFFE9E9E9)),
                        ),
                        child: Text(
                          "See more",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191919),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset(
                        "assets/images/reward_scholar.png",
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        "assets/images/reward_sci.png",
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        "assets/images/hidden_reward.png",
                        height: 50,
                      ),
                      Image.asset(
                        "assets/images/hidden_reward.png",
                        height: 50,
                      ),
                      Image.asset(
                        "assets/images/hidden_reward.png",
                        height: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Your badges tell your story.",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA5A5A5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your referral code',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                            AssetsSvgImages.copy,
                            height: 12.r,
                            width: 12.r,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Referral link pill
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: '${userProfile.referralCode}'),
                          );
                        },
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: kPurple.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.link, size: 18, color: kPurple),
                              SizedBox(width: 8),
                              RichText(
                                text: TextSpan(
                                  // 'https://app.flowvahub.com?ref=${userProfile!.referralCode}',
                                  text: '${userProfile!.referralCode}',
                                  style: TextStyles.bodySemiBold16(
                                    context,
                                  ).copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            FlowvaButton.blueButton(
                              name: "Share Referral Code",
                              color: Colors.white,
                              icon: Image.asset(
                                "assets/images/share.png",
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Progress row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // coin circle
                                Image.asset(
                                  "assets/images/one_50.png",
                                  height: 50,
                                ),
                                const SizedBox(width: 12),
                                // center column with next unlock and progress
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'First 10 referrals :',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Text(
                                          //   '${userProfile.referralCount}',
                                          //   style: GoogleFonts.manrope(
                                          //     fontSize: 14,
                                          //     fontWeight: FontWeight.w700,
                                          //     color: kPurple,
                                          //   ),
                                          // ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${userProfile.referralCount} ",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 16,
                                                    color: kPurple,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "/1000",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: LinearProgressIndicator(
                                            minHeight: 8,
                                            value:
                                                (userProfile.referralCount ??
                                                    0) /
                                                10, // 1 / 10 shown in screenshot
                                            backgroundColor: kLightGray,
                                            valueColor: AlwaysStoppedAnimation(
                                              kPurple,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // right fraction
                              ],
                            ),
                            SizedBox(height: 25),
                            // you referred row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'You referred',
                                        style: TextStyles.smallMedium12(
                                          context,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/images/user.png"),
                                    SizedBox(width: 6.w),
                                    RichText(
                                      text: TextSpan(
                                        text: "${userProfile.referralCount}",
                                        style: TextStyles.bodySemiBold16(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                rewardsSummary.isNotEmpty && rewardsSummary.length > 2
                    ? LeaderboardPage(rewardsSummary: rewardsSummary)
                    : Container(),
                SizedBox(height: 20.h),
              ],
            ),
    );
  }

  // 🔹 Points Card
  Widget _pointsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Total Coin Earned",
            style: GoogleFonts.baloo2(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Color(0xFF70403E),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset("assets/images/one_50.png", height: 48),

          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${userProfile.totalPoints}",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "/ ${userProfile.basePoints}",
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF5F5F5F),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:
                  (userProfile.totalPoints ?? 0) /
                  (userProfile.basePoints ?? 5000)!,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA259FF)),
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Just 1,386 coins until your next win!",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Mission Card
  Widget _missionCard() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Center(
            child: Container(
              height: 60,
              width: 60,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    child: Image.asset("assets/images/one_50.png", height: 48),
                  ),
                  Positioned(
                    top: 1,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.06),
                        //     blurRadius: 6,
                        //   ),
                        // ],
                      ),
                      child: Text(
                        "\$\$\$",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: Color(0xFF9013FE),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Growth Missions",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  " 👉 Tap to explore more missions",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5F5F5F),
                  ),
                ),
              ],
            ),
          ),
          FlowvaButton.ballButton(
            color: Colors.white,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight02,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Streak Section
  Widget _streakCard({required Function? apply}) {
    return Container(
      height: 408,
      decoration: BoxDecoration(
        color: Color(0xFFF6EDFE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🔥", style: TextStyle(fontSize: 40)),
          const SizedBox(height: 4),
          Text(
            "${streaks.currentStreak ?? "0"}-Days Streak",
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You’ve checked in ${streaks.currentStreak ?? "0"} days straight. Keep it going!",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF767676),
            ),
          ),

          // Days row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                List<String> weekStartingSunday = days.reversed
                    .take(streaks.currentStreak ?? 0)
                    .toList();
                return Column(
                  children: [
                    Text(
                      day,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    weekStartingSunday.contains(day)
                        ? Icon(
                            Icons.check_circle,

                            size: 22,
                            color: Color(0xFFFF8687),
                          )
                        : ["Sun"].contains(day)
                        ? Text("🔥", style: TextStyle(fontSize: 22))
                        : Icon(
                            Icons.circle_outlined,
                            size: 22,
                            color: Color(0xFFA5A5A5),
                          ),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // ProgressTrack(),
                FlowvaButton.blueButton(
                  name: "Check-in today",
                  color: Colors.white,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedTickDouble02,
                    color: Colors.white,
                  ),
                  apply: apply,
                ),
                const SizedBox(height: 5),
                FlowvaButton.whiteButton(
                  name: "Share my streak",
                  color: Colors.black,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedShare08,
                    color: Colors.black,
                    size: 20,
                  ),
                ),

                // Divider(height: 30, color: Colors.black.withOpacity(0.07)),
                // Progress row
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressTrack extends StatelessWidget {
  /// progress from 0.0 .. 1.0
  final double progress;

  ProgressTrack({super.key, this.progress = 0.4});

  // marker positions relative to track width (0..1)
  final List<double> markerPositions = [0.02, 0.35, 0.66, 0.95];

  // You can replace these emoji strings with asset paths and use Image.asset
  final List<String> markerIcons = ['🌑', '🌤️', '🌞', '🔥'];

  @override
  Widget build(BuildContext context) {
    const double arrowSize = 40;
    return Row(
      children: [
        // Left circular arrow
        _arrowButton(icon: Icons.chevron_left, onTap: () {}),
        const SizedBox(width: 5),

        // Center track
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // padding on left/right inside the card for the track
              final double horizontalPadding = 20;
              final double trackLeft = horizontalPadding;
              final double trackWidth =
                  constraints.maxWidth - horizontalPadding * 2;
              const double trackHeight = 8.0;
              const double markerSize = 40.0;

              return SizedBox(
                height: 80, // space to draw track + markers
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // background (light gray) track
                    Positioned(
                      top: 28,
                      left: trackLeft,
                      child: Container(
                        width: trackWidth,
                        height: trackHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // filled progress (purple)
                    Positioned(
                      top: 28,
                      left: trackLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        width: trackWidth * (progress.clamp(0.0, 1.0)),
                        height: trackHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF9B6BFF),
                              const Color(0xFFB58BFF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // markers (icons) positioned along the track
                    for (var i = 0; i < markerPositions.length; i++)
                      Positioned(
                        top: 28 - (markerSize / 2) + (trackHeight / 2),
                        left:
                            trackLeft +
                            (markerPositions[i].clamp(0.0, 1.0) * trackWidth) -
                            (markerSize / 2),
                        child: _buildMarker(
                          markerIcons[i],
                          markerSize,
                          isActive: (progress >= markerPositions[i]),
                        ),
                      ),
                    Positioned(
                      bottom: 10,
                      left: trackWidth * (progress.clamp(0.0, 1.0)),
                      child: Text(
                        'Steady',
                        style: TextStyle(
                          color: const Color(0xFF7B34FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // left handle decorative (optional small shadow dot)
                    // right handle decorative not required (arrows outside)
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 5),
        // Right circular arrow
        _arrowButton(icon: Icons.chevron_right, onTap: () {}),
      ],
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMarker(String emoji, double size, {required bool isActive}) {
    // active = the progress has passed that marker -> apply a glow or colored background
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
