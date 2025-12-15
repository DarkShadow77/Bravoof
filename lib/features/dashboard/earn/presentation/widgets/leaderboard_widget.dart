import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF9419FD); // Purple gradient base
  final Color secondaryColor = Color(0xFFFDD3D8);
  List<RewardsSummary>rewardsSummary=[];
  LeaderboardPage({required this.rewardsSummary});

  @override
  Widget build(BuildContext context) {
    rewardsSummary.sort((a, b) => b.totalPointRedeemed!.compareTo(a.totalPointRedeemed!));

    final first = rewardsSummary[0];
    final second = rewardsSummary.length > 1 ? rewardsSummary[1] : null;
    final third = rewardsSummary.length > 2 ? rewardsSummary[2] : null;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Leaderboard Info
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Leaderboard',
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
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

          SizedBox(height: 20),
          // Podium
          Container(
            height: 165,
            child: Stack(
              alignment: Alignment.topCenter,

              children: [
                Positioned(
                  top: 50,
                  left: 30,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:NetworkImage(second!.userProfile!.profilePic!),
                      ),
                      SizedBox(height: 8),
                      Text(second.userProfile!.name.toString(), style: TextStyle(color: Colors.white)),
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
                              "${second.totalPointRedeemed}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(first!.userProfile!.profilePic!),
                      ),
                      SizedBox(height: 8),
                      Text(
                        first.userProfile!.name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                              "${first.totalPointRedeemed}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 30,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(third!.userProfile!.profilePic!),
                      ),
                      SizedBox(height: 8),
                      Text(third.userProfile!.name.toString(), style: TextStyle(color: Colors.white)),
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
                              "${third.totalPointRedeemed}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 20),
          SizedBox(
            height: 420,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // ✅ Podium positioned from the bottom
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      podiumBlock(
                        position: 2,
                        height: 115,
                        color: Color(0xFF6312A8),
                      ),

                      podiumBlock(
                        position: 1,
                        height: 140,
                        color: Color(0xFF7B24E8),
                      ),

                      podiumBlock(
                        position: 3,
                        height: 100,
                        color: Color(0xFF6312A8),
                      ),
                    ],
                  ),
                ),

                // Leaderboard overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 275,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ...rewardsSummary.map((e){
                          return  leaderboardTile(
                            rank: 1,
                            name: e.userProfile!.name!,
                            role: e.userProfile!.bio!,
                            score: e.totalPointRedeemed.toString(),
                            image: e.userProfile!.profilePic!,

                          );
                        })


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Leader List
          SizedBox(height: 20),
          FlowvaButton.whiteButton(
            color: Colors.black,
            name: 'See Leaderboard',
          ),
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

  Widget podiumBlock({
    required int position,
    required double height,
    required Color color,
  }) {
    final Color topFaceColor = lighten(color, 0.2);
    final Color frontFaceColor = color;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Front face (main block)
        Container(
          width: 108.1,
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(5),
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
              width: 103.11,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFFCA8DFD),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
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
