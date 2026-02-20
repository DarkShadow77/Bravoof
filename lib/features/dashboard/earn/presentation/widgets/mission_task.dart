import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/earn/presentation/pages/jackpot_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionsTaskScreen extends StatefulWidget {
  const MissionsTaskScreen({Key? key}) : super(key: key);

  @override
  State<MissionsTaskScreen> createState() => _MissionsTaskScreenState();
}

class _MissionsTaskScreenState extends State<MissionsTaskScreen> {
  String selectedCategory = 'All';

  // Dummy mission data
  final List<Map<String, dynamic>> missions = [
    {
      'title': 'Share Your Streak',
      'desc': "Share your streak online to get 50 coins",
      'icon': Image.asset("assets/images/person1.png", fit: BoxFit.contain),
      'coins': 50,
      'progress': 1 / 3,
      'actionLabel': 'Share',
      'enabled': true,
    },

    {
      'title': 'Invite 5 friends to Bravoo',
      'desc':
          "Invite 5 friends every month to play the Bravoo Jackpot and win up to 20,000 coins",
      'icon': Image.asset("assets/images/person1.png", fit: BoxFit.contain),
      'coins': 'x1',
      'progress': 1 / 3,
      'actionLabel': 'Invite',
      'enabled': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFFF6F9);
    final cardBg = Colors.white;
    final accent = const Color(0xFF8A3BFF); // purple accent
    final softGray = Colors.black.withOpacity(0.55);
    final Color g1 = const Color(0xFF7367F0).withOpacity(0.5);
    final Color g2 = const Color(0xFFFF8A80).withOpacity(0.5);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            // AppBar row
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: const Icon(Icons.arrow_back, size: 25),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Growth Missions',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Header big card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.98),
                    Colors.pink.shade50.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Your Growth Begins With a Mission',
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9013FE),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 59,
                    height: 59,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(100),
                          ),

                          child: Container(
                            height: 100,
                            width: 100,
                            child: Transform.rotate(
                              angle: -0.14 / 2,
                              child: CircularProgressIndicator(
                                value: 1 / 5,
                                strokeWidth: 6,
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF9013FE),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '4/7',
                          style: GoogleFonts.baloo2(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFA87D7D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "You’re building real momentum. Keep going! ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF767676),
                    ),
                  ),
                  // Circular progress + text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Unlock spins card (mini)
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => JackpotScreen()),
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unlock spins by completing missions',
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2B2B2B),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // thin progress bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: 4 / 7,
                                        minHeight: 8,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              accent,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '1 spin available, go to jackpot',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF6B16CA),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // small wheel icon card
                              const SizedBox(width: 10),

                              Container(
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,

                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Purple soft central glow
                                            Positioned(
                                              left: 10,
                                              right: 10,
                                              bottom: 0,
                                              // same base as the button so glow sits behind it
                                              child: Center(
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 44,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      // Purple soft central glow
                                                      Container(
                                                        width: 80,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                60,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  const Color(
                                                                    0xFF7367F0,
                                                                  ).withOpacity(
                                                                    0.5,
                                                                  ),
                                                              blurRadius: 4,
                                                              spreadRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Red/pink subtle offset glow (left side)
                                                      Positioned(
                                                        left: 0,
                                                        right: 20,
                                                        child: Container(
                                                          width: 120,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  60,
                                                                ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    const Color(
                                                                      0xFFFF8A80,
                                                                    ).withOpacity(
                                                                      0.5,
                                                                    ),
                                                                blurRadius: 25,
                                                                spreadRadius:
                                                                    10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // The floating Focus button (on top of the glow)
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 10,
                                              child: Image.asset(
                                                "assets/images/spin.png",
                                                fit: BoxFit.contain,
                                                height: 24,
                                                width: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        'x1',
                                        style: GoogleFonts.baloo2(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black.withOpacity(0.34),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Mission cards
            Column(
              children: missions.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _missionCard(
                    context,
                    icon: m['icon'],
                    title: m['title'],
                    desc: m['desc'],
                    coins: m['coins'].toString(),
                    progress: (m['progress'] as double),
                    actionLabel: m['actionLabel'],
                    enabled: m['enabled'] as bool,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            // Quote / CTA area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.32),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '“Your growth is happening, even in small moments…”',
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.25),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FlowvaButton.whiteButton(
                      name: "See previous missions",
                      color: Color(0xFF020617),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // bottom padding
          ],
        ),
      ),
    );
  }

  Widget _missionCard(
    BuildContext context, {
    required Widget icon,
    required String title,
    required String desc,
    required String coins,
    required double progress,
    required String actionLabel,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🟣 Leading Icon
          Center(
            child: SizedBox(
              height: 35,
              width: 40,
              // height of your card’s content area (adjust as needed)
              child: icon,
            ),
          ),
          SizedBox(width: 5),

          // 🟢 Title, desc, and progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.baloo2(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFAB7A7A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5F5F5F),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),

          // const SizedBox(width: 10),

          // 🟡 Trailing Widget
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ prevents overflow
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/one_50.png",
                      fit: BoxFit.contain,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$coins',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                FlowvaButton.purpleButton(
                  name: actionLabel,
                  // fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _progressTextFromValue(double progress) {
    // simple mapping for demo: 0 -> 0/1, 1/3 -> 1/3, etc.
    if (progress == 0.0) return '0/1';
    if ((progress - 1 / 3).abs() < 0.01) return '1/3';
    // fallback
    return '${(progress * 1).round()}/${1}';
  }
}
