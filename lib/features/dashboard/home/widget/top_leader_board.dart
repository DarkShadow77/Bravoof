import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'leader_board.dart';

class TopLeaderBoard extends StatelessWidget {
  List<RewardsSummary> rewardsSummary = [];
  TopLeaderBoard({required this.rewardsSummary, super.key});

  @override
  Widget build(BuildContext context) {
    rewardsSummary.sort(
      (a, b) => b.totalPointRedeemed!.compareTo(a.totalPointRedeemed!),
    );

    final first = rewardsSummary[0];
    final second = rewardsSummary.length > 1 ? rewardsSummary[1] : null;
    final third = rewardsSummary.length > 2 ? rewardsSummary[2] : null;
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
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                second!.userProfile!.profilePic!,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8687).withOpacity(0.54),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
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
                        second.userProfile!.name.toString(),
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
                          color: Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/one_50.png", height: 14),
                            const SizedBox(width: 6),
                            Text(
                              second.totalPointRedeemed.toString(),
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
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                first.userProfile!.profilePic!,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFAC60A).withOpacity(0.54),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
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
                        first.userProfile!.name.toString(),
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
                              first.totalPointRedeemed.toString(),
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
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                third!.userProfile!.profilePic!,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFF72410A).withOpacity(0.54),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
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
                        third.userProfile!.name.toString(),
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
                              third.totalPointRedeemed.toString(),
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
                MaterialPageRoute(
                  builder: (ctx) =>
                      LeaderboardScreen(leaderboardList: rewardsSummary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
