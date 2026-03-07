/*
import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:google_fonts/google_fonts.dart';

import '../page/trivia_result_page.dart';

class GameSuccess extends StatefulWidget {
  int? score;
  int? totalQuestion;
  GameSuccess({this.score, this.totalQuestion, super.key});

  @override
  State<GameSuccess> createState() => _GameSuccessState();
}

class _GameSuccessState extends State<GameSuccess> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blur Background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: Colors.black.withValues(alpha:0.2)),
        ),

        // Dialog with Confetti Stack
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFDFBFD), Color(0xFFF5F5F7)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Great Job! ☺️",
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Your points just increased.",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F5F5F),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Final \nScore ${widget.score}/${widget.totalQuestion}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF008753),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                FlowvaButton.whiteButton(
                  name: "See how you did",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>
                          TriviaResultScreen(yourScore: widget.score),
                    ),
                  ),
                  color: Colors.black,
                ),
                FlowvaButton.successPurpleButton(
                  name: "Explore more missions",
                  apply: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(index: 1),
                    ),

                    (ctx) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
*/
