import 'dart:math' as math;

import 'package:flowva/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool selectedOption=false;
  @override
  Widget build(BuildContext context) {
    final leaderboard = [
      {
        "rank": "🏆",
        "name": "Jay",
        "points": "26,120",
        "image": "assets/avatar/1.png",
      },
      {
        "rank": "🥈",
        "name": "John Wick",
        "points": "15,160",
        "image": "assets/avatar/2.png",
      },
      {
        "rank": "🥉",
        "name": "Hank Pym",
        "points": "15,160",
        "image": "assets/avatar/3.png",
      },
      {
        "rank": "4",
        "name": "Diana Prince",
        "points": "15,160",
        "image": "assets/avatar/4.png",
      },
      {
        "rank": "8",
        "name": "Oliver Quin (You)",
        "role": "Development",
        "points": "15,160",
        "image": "assets/avatar/5.png",
        "highlight": true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(

            children: [
              // Leaderboard title
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: ()=>Navigator.pop(context),
                      child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28)),
                  SizedBox(width: 20,),
                  Text(
                    "LeaderBoard",
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const Icon(Icons.more_horiz, size: 22),
                ],
              ),


              // Top Profile Highlight
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          // Rotate slightly counterclockwise (~ -5 degrees)
                          transform: Matrix4.identity()
                            ..rotateZ(5 * math.pi / 180),
                          child: Container(
                            width: 77,
                            height: 89,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/avatar/1.png',
                              fit: BoxFit.cover,
                            ),
                          ),

                        ),

                        const SizedBox(height: 10),
                        Text(
                          "Jay",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Text(
                        //   "Design",
                        //   style: GoogleFonts.manrope(
                        //     color: Color(0xFF767676),
                        //     fontSize: 12,
                        //   ),
                        // ),
                        const SizedBox(height: 10),

                        // Coin + Points
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
                              Image.asset("assets/images/one_50.png", height: 32),
                              const SizedBox(width: 6),
                              Text(
                                "26,120",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Cheer button
                    FlowvaButton.purple_Button(name: "👏Cheer"),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10,right:10,top: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(30),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.06),
                        //     blurRadius: 6,
                        //   ),
                        // ],
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Leaderboard",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Tab indicator
                          const SizedBox(height: 16),

                          // List items
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: leaderboard.length,
                              itemBuilder: (context,i){
                                final selected = leaderboard[i]['highlight'] == true;
                                final highlight=(i+1)%2==0;
                                print(i);
                                print(highlight);
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      leaderboard[i]['highlight']=true;
                                    });
                                  },
                                  child: Container(

                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color:highlight?Colors.white: selected ? const Color(0xFFF5ECFF) : Colors.black.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(8),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.05),
                                      //     blurRadius: 6,
                                      //   ),
                                      // ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        // Rank
                                        Container(
                                          width: 32,
                                          alignment: Alignment.center,
                                          child: Text(
                                            leaderboard[i]["rank"].toString(),
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),

                                        // Avatar
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.asset(
                                            leaderboard[i]["image"].toString(),
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),

                                        // Name and Role
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                leaderboard[i]["name"].toString(),
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                leaderboard[i]["role"].toString(),
                                                style: GoogleFonts.manrope(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF767676),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Points
                                        Row(
                                          children: [
                                            Image.asset("assets/images/one_50.png", height: 22),
                                            const SizedBox(width: 4),
                                            Text(
                                              leaderboard[i]["points"].toString(),
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })

                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Leaderboard List

            ],
          ),
        ),
      ),
    );
  }

}