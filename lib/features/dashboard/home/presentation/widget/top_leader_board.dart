import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/home/data/model/leaderboard_response_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../page/leaderboard_screen.dart';

class TopLeaderboard extends StatelessWidget {
  final List<LeaderboardModel> leaderboard;
  TopLeaderboard({required this.leaderboard, super.key});

  @override
  Widget build(BuildContext context) {
    leaderboard.sort((a, b) => b.totalEarned.compareTo(a.totalEarned));

    final first = leaderboard[0];
    final second = leaderboard.length > 1 ? leaderboard[1] : null;
    final third = leaderboard.length > 2 ? leaderboard[2] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9419FD), Color(0xFFFDD3D8)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Leaderboard Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/left_hand.png"),
                Text(
                  'Celebrate Consistency',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Image.asset("assets/images/right_hand.png"),
              ],
            ),
            SizedBox(height: 20),

            // Podium
            Container(
              height: 165,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: second!.profileImage,
                              size: 70,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.redBrown50,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: Text(
                                    "2",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 8),
                      Text(
                        second.name,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/one_50.png", height: 14),
                            const SizedBox(width: 6),
                            Text(
                              second.totalEarned.toString(),
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: first.profileImage,
                              size: 80,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.orange50,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: Text(
                                    "1",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        first.name.toString(),
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
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
                              first.totalEarned.toString(),
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: third!.profileImage,
                              size: 70,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF72410A,
                                  ).withValues(alpha: 0.54),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: Text(
                                    "3",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        third.name.toString(),
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
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
                              third.totalEarned.toString(),
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Rank resets in 7 days',
              style: GoogleFonts.baloo2(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFF1F1F1),
              ),
            ),
            SizedBox(height: 20),
            FlowvaButton.whiteButton(
              color: Colors.black,
              name: 'See Leaderboard',
              apply: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => LeaderboardScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
