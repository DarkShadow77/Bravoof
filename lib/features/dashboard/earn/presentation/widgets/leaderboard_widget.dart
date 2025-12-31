import 'dart:developer';

import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../home/presentation/widget/leader_board.dart';

class LeaderboardPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF9419FD); // Purple gradient base
  final Color secondaryColor = Color(0xFFFDD3D8);
  List<RewardsSummary> rewardsSummary = [];
  final bool fullScreen;
  LeaderboardPage({required this.rewardsSummary, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    rewardsSummary.sort(
      (a, b) => b.totalPointRedeemed!.compareTo(a.totalPointRedeemed!),
    );

    final List<RewardsSummary> listAfterTop3 = rewardsSummary.length > 3
        ? rewardsSummary.sublist(3)
        : [];

    final List<RewardsSummary> leaderboardList = fullScreen
        ? listAfterTop3
        : listAfterTop3.take(4).toList();

    final first = rewardsSummary[0];
    final second = rewardsSummary.length > 1 ? rewardsSummary[1] : null;
    final third = rewardsSummary.length > 2 ? rewardsSummary[2] : null;

    log("Leaderboards ${rewardsSummary}");
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: Column(
        children: [
          // Top Leaderboard Info
          if (fullScreen) SizedBox(height: MediaQuery.of(context).padding.top),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20.w,
                children: [
                  if (fullScreen)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20.sp,
                        color: AppColors.white,
                      ),
                    ),
                  Text(
                    'Leaderboard',
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFC58F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF77A38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#49',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Keep the momentum going! You are number 49 this month!',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Podium
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Top3Widget(
                  isFullScreen: fullScreen,
                  summary: second,
                  position: 2,
                  podiumHeight: 115,
                  podiumColor: Color(0xFF6312A8),
                ),
                Top3Widget(
                  isFullScreen: fullScreen,
                  isFirst: true,
                  summary: first,
                  position: 1,
                  podiumHeight: 140,
                  podiumColor: Color(0xFF7B24E8),
                ),
                Top3Widget(
                  isFullScreen: fullScreen,
                  summary: third,
                  position: 3,
                  podiumHeight: 100,
                  podiumColor: Color(0xFF6312A8),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: 100.h, maxHeight: 330.h),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: leaderboardList.isEmpty
                ? Center(
                    child: Text(
                      'No more players yet',
                      style: GoogleFonts.manrope(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: leaderboardList.length,
                    physics: fullScreen
                        ? BouncingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemBuilder: (context, index) {
                      final leaderboard = leaderboardList[index];
                      return leaderboardTile(
                        rank: index + 4,
                        name: leaderboard.userProfile!.name!,
                        role: leaderboard.userProfile!.bio!,
                        score: leaderboard.totalPointRedeemed.toString(),
                        image: leaderboard.userProfile!.profilePic!,
                      );
                    },
                  ),
            /*child: Column(
                      children: [
                        ...rewardsSummary.asMap().entries.map((e) {
                          final index = e.key;
                          final leaderboard = e.value;
                          return leaderboardTile(
                            rank: index + 1,
                            name: leaderboard.userProfile!.name!,
                            role: leaderboard.userProfile!.bio!,
                            score: leaderboard.totalPointRedeemed.toString(),
                            image: leaderboard.userProfile!.profilePic!,
                          );
                        }),
                      ],
                    ),*/
          ),
          if (!fullScreen) ...[
            // Leader List
            SizedBox(height: 10.h),
            FlowvaButton.whiteButton(
              color: Colors.black,
              name: 'See Leaderboard',
              apply: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        LeaderboardScreen(leaderboardList: rewardsSummary),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget leaderboardTile({
    required int rank,
    required String name,
    required String role,
    required String score,
    required String image,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (rank <= 3)
                Image.asset('assets/images/badge.png', width: 32, height: 32),
              if (rank > 3)
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '$rank',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF767676),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(30),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.06),
              //     blurRadius: 6,
              //   ),
              // ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/one_50.png", height: 12),
                const SizedBox(width: 6),
                Text(
                  score,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userColumn({
    required String name,
    required String image,
    required String score,
    required Color badgeColor,
    required Color positionColor,
    bool showMedal = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(image)),
            if (showMedal)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: badgeColor,
                  child: Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: positionColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bubble_chart, color: Colors.white70, size: 16),
            SizedBox(width: 4),
            Text(score, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}

Widget podiumBlock({
  bool isFull = true,
  required int position,
  required double height,
  required Color color,
}) {
  final Color frontFaceColor = color;
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      // Front face (main block)
      Container(
        width: isFull ? 108.w : 98.w,
        height: height,
        decoration: BoxDecoration(
          color: position == 1 ? null : frontFaceColor,
          gradient: position == 1
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6312A8), Color(0xFF9720FC)],
                )
              : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(5.r),
          ),
        ),
        alignment: Alignment.bottomCenter,

        child: Text(
          '$position',
          style: GoogleFonts.baloo2(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
              color: Color(0xFFCA8DFD),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ),
      ),
    ],
  );
}

class Top3Widget extends StatelessWidget {
  const Top3Widget({
    super.key,
    this.isFirst = false,
    this.isFullScreen = false,
    required this.position,
    required this.podiumHeight,
    required this.podiumColor,
    this.summary,
  });

  final bool isFirst;
  final bool isFullScreen;
  final int position;
  final double podiumHeight;
  final Color podiumColor;
  final RewardsSummary? summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: isFirst ? 40.r : 32.r,
              backgroundColor: AppColors.grey300,
              backgroundImage: summary != null
                  ? NetworkImage(summary!.userProfile!.profilePic!)
                  : null,
            ),
            SizedBox(height: 8.h),
            if (summary != null) ...[
              RichText(
                text: TextSpan(
                  text: summary!.userProfile?.name ?? "--",
                  style: TextStyles.smallRegular12(context).copyWith(
                    color: AppColors.white,
                    fontWeight: isFirst ? FontWeight.bold : null,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                spacing: 6.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12.h,
                    width: 12.w,
                    child: Image.asset(
                      AssetsPngImages.one50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: summary!.totalPointRedeemed.toString(),
                      style: TextStyles.cardSemibold10(
                        context,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ] else ...[
              RichText(
                text: TextSpan(
                  text: "No Record",
                  style: TextStyles.cardSemibold10(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
              ),
            ],
            SizedBox(height: 10.h),
            podiumBlock(
              position: position,
              height: podiumHeight.h,
              color: podiumColor,
              isFull: isFullScreen,
            ),
          ],
        ),
      ],
    );
  }
}
