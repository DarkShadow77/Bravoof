import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withOpacity(0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.48,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // translucent
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      width: 60,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Header with close button
                    Image.asset("assets/images/mission_win.png"),

                    const SizedBox(height: 16),
                    Text(
                      "Level Up on Bravoo!",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Every mission brings fun, learning, and rewards. Earn coins, unlock bonuses and participate in fun surprises are ",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    FlowvaButton.blueButton(
                      name: "Let’s do this!",
                      apply: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
