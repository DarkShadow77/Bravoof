import 'dart:async';
import 'dart:math';

import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/common/wins_pop.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/constants/app_assets.dart';

class GridItem {
  final String type;
  final int value;
  final String emoji;

  GridItem({required this.type, required this.value, required this.emoji});
}

class JackpotScreen extends StatefulWidget {
  const JackpotScreen({super.key});

  @override
  State<JackpotScreen> createState() => _JackpotScreenState();
}

class _JackpotScreenState extends State<JackpotScreen> with UIToolMixin {
  int selectedIndex = 7;
  int currentPosition = 0;
  bool isSpinning = false;
  int spinsLeft = 3;
  GridItem? winner;
  bool showResult = false;
  Timer? spinTimer;
  final Random random = Random();

  // Define grid items
  final List<GridItem> gridItems = [
    // Section 1 - Row 1 (4 items)
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),

    // Section 2 - Rows 2-3 (8 items)
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),

    // Section 3 - Rows 4-6 (12 items)
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.jackpot),
    GridItem(type: 'coins', value: 50, emoji: "assets/images/one_50.png"),
  ];

  @override
  void dispose() {
    spinTimer?.cancel();
    super.dispose();
  }

  // RECOMMENDED: Most flexible version with clear speed controls
  void handleSpin() {
    if (spinsLeft <= 0 || isSpinning) return;

    setState(() {
      isSpinning = true;
      showResult = false;
      winner = null;
    });

    // Random duration between 3-5 seconds
    final spinDuration = 3000 + random.nextInt(2000);
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // SPEED CONTROL: Increase these values to slow down
    int initialSpeed = 100; // Changed from 50 to 100 (slower start)
    int slowdownMultiplier = 500; // Changed from 300 to 500 (slower end)

    spinTimer = Timer.periodic(Duration(milliseconds: initialSpeed), (timer) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
      final progress = elapsed / spinDuration;

      // Slow down as we approach the end
      if (progress > 0.7) {
        timer.cancel();
        int newSpeed = (initialSpeed + (progress - 0.7) * slowdownMultiplier)
            .toInt();

        spinTimer = Timer.periodic(Duration(milliseconds: newSpeed), (
          slowTimer,
        ) {
          final newElapsed = DateTime.now().millisecondsSinceEpoch - startTime;
          if (newElapsed >= spinDuration) {
            slowTimer.cancel();
            stopSpinning();
          } else {
            setState(() {
              currentPosition = (currentPosition + 1) % gridItems.length;
            });
          }
        });
      } else {
        setState(() {
          currentPosition = (currentPosition + 1) % gridItems.length;
        });
      }

      if (elapsed >= spinDuration) {
        timer.cancel();
        stopSpinning();
      }
    });
  }

  // ALTERNATIVE: Better approach with smoother deceleration
  void handleSpinSmooth() {
    if (spinsLeft <= 0 || isSpinning) return;

    setState(() {
      isSpinning = true;
      showResult = false;
      winner = null;
    });

    final spinDuration = 4000; // 4 seconds total
    final startTime = DateTime.now().millisecondsSinceEpoch;

    void animate() {
      final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
      final progress = elapsed / spinDuration;

      if (progress >= 1.0) {
        stopSpinning();
        return;
      }

      // Calculate speed based on progress (gets slower over time)
      // Adjust these values to control speed:
      int baseSpeed = 80; // Starting speed (lower = faster)
      int maxSpeed = 400; // Ending speed (higher = slower at end)

      // Ease-out curve for natural deceleration
      double easedProgress = 1 - (1 - progress) * (1 - progress);
      int currentSpeed = (baseSpeed + (maxSpeed - baseSpeed) * easedProgress)
          .toInt();

      setState(() {
        currentPosition = (currentPosition + 1) % gridItems.length;
      });

      spinTimer = Timer(Duration(milliseconds: currentSpeed), animate);
    }

    animate();
  }

  // RECOMMENDED: Fixed version with proper speed control
  void handleSpinFixed() {
    if (spinsLeft <= 0 || isSpinning) return;

    setState(() {
      isSpinning = true;
      showResult = false;
      winner = null;
    });

    // ===== SPEED CONFIGURATION =====
    // INCREASE these values to make it SLOWER:
    const int startSpeedMs = 150; // Time between moves at start (try 150-300)
    const int endSpeedMs = 800; // Time between moves at end (try 600-1200)
    const int totalDurationMs = 5000; // Total spin time (try 4000-6000)
    const double slowdownAt = 0.7; // When to start slowing (0.6-0.8)
    // ===============================

    final startTime = DateTime.now();
    int moveCount = 0;

    void scheduleNextMove() {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final progress = elapsed / totalDurationMs;

      if (progress >= 1.0) {
        stopSpinning();
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.3),
          builder: (_) => WinsPop(),
        );
        Future.delayed(Duration(seconds: 3), () => Navigator.pop(context));

        return;
      }

      // Calculate delay until next move
      int delayMs;
      if (progress < slowdownAt) {
        // Constant speed in first phase
        delayMs = startSpeedMs;
      } else {
        // Smooth deceleration in second phase
        double slowdownProgress = (progress - slowdownAt) / (1 - slowdownAt);
        // Use quadratic easing for smoother slowdown
        double easedProgress = slowdownProgress * slowdownProgress;
        delayMs = (startSpeedMs + (endSpeedMs - startSpeedMs) * easedProgress)
            .round();
      }

      // Move to next position after delay
      spinTimer = Timer(Duration(milliseconds: delayMs), () {
        if (mounted) {
          setState(() {
            currentPosition = (currentPosition + 1) % gridItems.length;
            moveCount++;
          });
          scheduleNextMove();
        }
      });
    }

    scheduleNextMove();
  }

  // ALTERNATIVE: Even simpler with periodic timer but correct speed
  void handleSpinSimple() {
    if (spinsLeft <= 0 || isSpinning) return;

    setState(() {
      isSpinning = true;
      showResult = false;
      winner = null;
    });

    // Control the base speed here - HIGHER = SLOWER
    const int baseDelayMs = 200; // Start with 200ms between each move
    const int maxDelayMs = 1000; // End with 1000ms between each move

    final totalMoves = gridItems.length * 3; // Go around 3 times
    int moveCount = 0;

    void doMove() {
      if (moveCount >= totalMoves) {
        stopSpinning();
        return;
      }

      // Calculate current delay based on progress
      double progress = moveCount / totalMoves;
      int currentDelay =
          (baseDelayMs + (maxDelayMs - baseDelayMs) * progress * progress)
              .round();

      setState(() {
        currentPosition = (currentPosition + 1) % gridItems.length;
        moveCount++;
      });

      spinTimer = Timer(Duration(milliseconds: currentDelay), doMove);
    }

    doMove();
  } // Example: highlight center box

  void stopSpinning() {
    final finalPosition = random.nextInt(gridItems.length);

    setState(() {
      currentPosition = finalPosition;
      isSpinning = false;
      winner = gridItems[finalPosition];
      showResult = true;
      spinsLeft--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C0066),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 0),
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/enter_win_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4),
                            // fine-tune so it matches first line
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Spin a Jackpot",
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 140,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Front face (main block)
                        Positioned.fill(
                          top: 30,
                          bottom: 0,
                          child: Container(
                            width: 380,
                            height: 100,
                            decoration: BoxDecoration(color: Color(0xFF550AA9)),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 10,
                              bottom: 5,
                            ),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFF5B17C6),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.8,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "FLOWVA’S",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/star.png"),
                                    // const SizedBox(width: 8),
                                    Image.asset(
                                      "assets/images/jackpot.png",
                                      height: 60,
                                    ),
                                    // const SizedBox(width: 8),
                                    Image.asset("assets/images/star.png"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Top face (angled using Transform)
                        Positioned(
                          top: -10,
                          child: Center(
                            child: ClipPath(
                              clipper: _TopInwardClipper(),
                              child: Container(
                                width: 390,
                                height: 40,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF3A0874),
                                      Color(0xFF371222),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🟦 Jackpot Grid (3D style)
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    color: const Color(0xFF400387),
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: 340,

                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF550AA9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Color(0xFF6B16CA)),
                        // boxShadow: const [
                        //   BoxShadow(
                        //     color: Colors.black26,
                        //     blurRadius: 12,
                        //     offset: Offset(0, 8),
                        //   ),
                        // ],
                      ),
                      child: Column(
                        children: [
                          buildGridSection(0, 4),
                          const SizedBox(height: 16),

                          // Section 2: 2 rows (8 items)
                          buildGridSection(4, 12),
                          const SizedBox(height: 16),

                          // Section 3: 3 rows (12 items)
                          buildGridSection(12, 24),
                          //  SizedBox(height: 80,
                          //  child:GridView.builder(
                          //    shrinkWrap: true,
                          //    itemCount: 4,
                          //    padding: EdgeInsets.symmetric(vertical: 10),
                          //    physics: const NeverScrollableScrollPhysics(),
                          //    gridDelegate:
                          //    const SliverGridDelegateWithFixedCrossAxisCount(
                          //        crossAxisCount: 4,
                          //        mainAxisSpacing: 14,
                          //        crossAxisSpacing: 14,
                          //        childAspectRatio: 1.5
                          //    ),
                          //    itemBuilder: (context, index) {
                          //      final isSelected = index == selectedIndex;
                          //      return AnimatedContainer(
                          //        duration: const Duration(milliseconds: 250),
                          //        decoration: BoxDecoration(
                          //          gradient: const LinearGradient(
                          //            colors: [Color(0xFF6A3CEB), Color(0xFF6A11CB)],
                          //            begin: Alignment.topLeft,
                          //            end: Alignment.bottomRight,
                          //          ),
                          //          borderRadius: BorderRadius.circular(12),
                          //          border: isSelected
                          //              ? Border.all(color: Colors.white, width: 2)
                          //              : null,
                          //          boxShadow: [
                          //            BoxShadow(
                          //              color: Colors.black.withOpacity(0.25),
                          //              blurRadius: 8,
                          //              offset: const Offset(0, 4),
                          //            ),
                          //          ],
                          //        ),
                          //        child: Center(
                          //          child: index % 2 == 0
                          //              ? _buildRewardIcon(
                          //            "assets/images/one_50.png",
                          //            "50",
                          //          )
                          //              : _buildRewardIcon(
                          //
                          //AssetsPngImages.jackpot,
                          //            "x${index % 3 + 1}",
                          //          ),
                          //        ),
                          //      );
                          //    },
                          //  ) ,),
                          // SizedBox(height: 130,
                          // child:  GridView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: 8,
                          //   padding: EdgeInsets.symmetric(vertical: 10),
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   gridDelegate:
                          //   const SliverGridDelegateWithFixedCrossAxisCount(
                          //       crossAxisCount: 4,
                          //       mainAxisSpacing: 10,
                          //       crossAxisSpacing: 14,
                          //       childAspectRatio: 1.5
                          //   ),
                          //   itemBuilder: (context, index) {
                          //     final isSelected = index == selectedIndex;
                          //     return AnimatedContainer(
                          //       duration: const Duration(milliseconds: 250),
                          //       decoration: BoxDecoration(
                          //         gradient: const LinearGradient(
                          //           colors: [Color(0xFF6A3CEB), Color(0xFF6A11CB)],
                          //           begin: Alignment.topLeft,
                          //           end: Alignment.bottomRight,
                          //         ),
                          //         borderRadius: BorderRadius.circular(12),
                          //         border: isSelected
                          //             ? Border.all(color: Colors.white, width: 2)
                          //             : null,
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.25),
                          //             blurRadius: 8,
                          //             offset: const Offset(0, 4),
                          //           ),
                          //         ],
                          //       ),
                          //       child: Center(
                          //         child: index % 2 == 0
                          //             ? _buildRewardIcon(
                          //           "assets/images/one_50.png",
                          //           "50",
                          //         )
                          //             : _buildRewardIcon(
                          //
                          // AssetsPngImages.jackpot,
                          //           "x${index % 3 + 1}",
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),),
                          // SizedBox(height: 170,
                          // child:  GridView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: 12,
                          //   padding: EdgeInsets.symmetric(vertical: 10),
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   gridDelegate:
                          //   const SliverGridDelegateWithFixedCrossAxisCount(
                          //       crossAxisCount: 4,
                          //       mainAxisSpacing: 10,
                          //       crossAxisSpacing: 14,
                          //       childAspectRatio: 1.5
                          //   ),
                          //   itemBuilder: (context, index) {
                          //     final isSelected = index == selectedIndex;
                          //     return AnimatedContainer(
                          //       duration: const Duration(milliseconds: 250),
                          //       decoration: BoxDecoration(
                          //         gradient: const LinearGradient(
                          //           colors: [Color(0xFF6A3CEB), Color(0xFF6A11CB)],
                          //           begin: Alignment.topLeft,
                          //           end: Alignment.bottomRight,
                          //         ),
                          //         borderRadius: BorderRadius.circular(12),
                          //         border: isSelected
                          //             ? Border.all(color: Colors.white, width: 2)
                          //             : null,
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.25),
                          //             blurRadius: 8,
                          //             offset: const Offset(0, 4),
                          //           ),
                          //         ],
                          //       ),
                          //       child: Center(
                          //         child: index % 2 == 0
                          //             ? _buildRewardIcon(
                          //           "assets/images/one_50.png",
                          //           "50",
                          //         )
                          //             : _buildRewardIcon(
                          //
                          //AssetsPngImages.jackpot,
                          //           "x${index % 3 + 1}",
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),),
                        ],
                      ),
                    ),
                  ),

                  // 🟣 Spin Button (3D gradient)
                  SizedBox(
                    height: 140,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Front face (main block)
                        Positioned.fill(
                          top: 30,
                          bottom: 0,
                          child: Container(
                            width: 380,
                            height: 100,
                            decoration: BoxDecoration(color: Color(0xFF550AA9)),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        Positioned(
                          top: 60,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: FlowvaButton.jackpotButton(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedRepeat,
                                color: isSpinning ? Colors.grey : Colors.white,
                              ),
                              name: isSpinning
                                  ? 'SPINNING...'
                                  : 'SPIN ($spinsLeft LEFT)',
                              color: isSpinning ? Colors.grey : Colors.white,
                              apply: () => (spinsLeft <= 0 || isSpinning)
                                  ? null
                                  : handleSpinFixed(),
                            ),
                          ),
                        ),
                        // Top face (angled using Transform)
                        Positioned(
                          top: -10,
                          child: Center(
                            child: ClipPath(
                              clipper: _TopInwardClipper(),
                              child: Container(
                                width: 400,
                                height: 40,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF3A0874),
                                      Color(0xFF371222),
                                    ],
                                  ),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGridSection(int startIdx, int endIdx) {
    final items = gridItems.sublist(startIdx, endIdx);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final actualIndex = startIdx + index;
        final item = items[index];
        final isSelected = currentPosition == actualIndex;
        final selectedTransform = Matrix4.identity()..scale(1.05);
        final normalTransform = Matrix4.identity();
        print(item.emoji);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            // color: isSelected
            //     ? const Color(0xFFAB47BC)
            //     : const Color(0xFF7B1FA2).withOpacity(0.6),
            gradient: const LinearGradient(
              colors: [Color(0xFF6A3CEB), Color(0xFF6A11CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: const Color(0xFFFFD700), width: 4)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          transform: isSelected ? selectedTransform : normalTransform,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.emoji,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              // Text(
              //   item.emoji,
              //   style: const TextStyle(fontSize: 32),
              // ),
              const SizedBox(width: 4),
              Text(
                item.type == 'coins' ? '${item.value}' : 'x${item.value}',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// 🟣 Custom Clipper for the sharp top trapezoid

class _TopInwardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double inwardOffset = 30; // how much to pull top corners inward

    // Start from bottom left
    path.moveTo(0, size.height);

    // bottom edge
    path.lineTo(size.width, size.height);

    // top right inward
    path.lineTo(size.width - inwardOffset, 0);

    // top left inward
    path.lineTo(inwardOffset, 0);

    // close back to bottom left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
