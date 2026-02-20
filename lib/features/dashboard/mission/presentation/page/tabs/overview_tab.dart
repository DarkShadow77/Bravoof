import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/earn/presentation/pages/badge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../earn/presentation/widgets/leaderboard_widget.dart';
import '../../../../home/presentation/bloc/home_cubit.dart';
import '../../../../home/presentation/widget/referral_widget.dart';
import '../../../../nav_bar.dart';
import '../../widget/streak_card.dart';
import '../../widget/total_points_card.dart';

class EarnOverviewScreen extends StatefulWidget {
  const EarnOverviewScreen({super.key});

  @override
  State<EarnOverviewScreen> createState() => _EarnOverviewScreenState();
}

class _EarnOverviewScreenState extends State<EarnOverviewScreen>
    with UIToolMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // Flowva Points Earned Card
          TotalPointsCard(),
          SizedBox(height: 20.h),
          // Missions Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BottomNavBar(index: 1, missionIndex: 1),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: _missionCard(),
          ),
          SizedBox(height: 20.h),
          // Streak Section
          StreakCard(),
          SizedBox(height: 20.h),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white50,
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
                Image.asset("assets/images/hidden_reward.png", height: 50),
                Image.asset("assets/images/hidden_reward.png", height: 50),
                Image.asset("assets/images/hidden_reward.png", height: 50),
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
          SizedBox(height: 20.h),
          // Referral card
          ReferralCard(),
          SizedBox(height: 20.h),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final leaderboard = state.leaderboard.leaderboard;
              if (leaderboard.isNotEmpty && leaderboard.length > 2)
                return LeaderboardPage();
              else
                return SizedBox.shrink();
            },
          ),
          SizedBox(height: 20.h),
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
