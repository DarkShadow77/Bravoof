import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/nav_bar.dart';
import 'package:bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillUpSuccess extends StatefulWidget {
  SkillUpSuccess({super.key});

  @override
  State<SkillUpSuccess> createState() => _SkillUpSuccessState();
}

class _SkillUpSuccessState extends State<SkillUpSuccess> {
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
          child: Container(color: Colors.black.withValues(alpha: 0.2)),
        ),

        // Dialog with Confetti Stack
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                  "Nice Work!",
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Image.asset("assets/images/check.png"),
                SessionManager().isLastMissionVal
                    ? Text(
                        "You have completed all current missions. New ones are coming! Your reward will appear in your account after confirmation.",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5F5F5F),
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        "Your reward will appear in your account after confirmation.",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5F5F5F),
                        ),
                        textAlign: TextAlign.center,
                      ),

                const SizedBox(height: 20),
                FlowvaButton.whiteButton(
                  name: SessionManager().isLastMissionVal
                      ? "Finish"
                      : "Continue to the next mission",
                  apply: () {
                    if (SessionManager().isLastMissionVal) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => BottomNavBar(index: 1),
                        ),

                        (ctx) => false,
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }

                    // Navigator.of(context).push(
                    //    MaterialPageRoute(
                    //      builder: (ctx) =>
                    //          SkillUpScreen(task: widget.skillUp),
                    //    ),
                    //  );
                  },
                  color: Colors.black,
                ),
                FlowvaButton.successPurpleButton(
                  name: "Back to missions",
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
