import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class RegistrationStepWidget extends StatelessWidget {
  const RegistrationStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': '2 of 5 Check-in',
        'desc': 'Check-in for the first time to start your Bravoo journey ☺️',
        'done': true,
      },
      {
        'title': '3 of 5 Mission',
        'desc': 'Complete your first mission and earn rewards',
        'done': false,
      },
      {
        'title': '4 of 5 Level-up',
        'desc': 'Level-up your first skill to unlock new potential',
        'done': false,
      },
      {
        'title': '5 of 5',
        'desc': 'Invite your first friend and earn 100  B-Coin as a thank you.',
        'done': false,
      },
    ];

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withValues(alpha: 0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.76,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return Container(
              // padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white, // translucent
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  // const SizedBox(height: 20),

                  // Top progress
                  SizedBox(
                    height: 140,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          top: -33,
                          child: Image.asset(
                            "assets/images/progress_bg.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 20,
                          child: Container(
                            height: 36,
                            width: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(120),
                              border: Border.all(
                                width: 0.2,
                                color: Colors.black.withValues(alpha: 0.6),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedCancel01,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 50,
                          left: 50,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.white,
                                    ),
                                  ),

                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Transform.rotate(
                                      angle: -0.14 / 2,
                                      child: CircularProgressIndicator(
                                        value: 1 / 5,
                                        strokeWidth: 4,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              Color(0xFF8A3FFC),
                                            ),
                                        backgroundColor: const Color(
                                          0xFFEAEAEA,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "2/5",
                                  style: GoogleFonts.manrope(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF9013FE),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Task list
                  ...tasks.map((task) {
                    final done = task['done'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                        right: 16,
                        left: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          task['title'] as String,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          task['desc'] as String,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5F5F5F),
                          ),
                        ),

                        leading: Image.asset(
                          "assets/images/one_50.png",
                          height: 34,
                        ),
                        trailing: done
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 22,
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black45,
                                size: 16,
                              ),
                        dense: true,
                        enabled: true,
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 0,
                        minVerticalPadding: 2,

                        // horizontalTitleGap: 0,
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
