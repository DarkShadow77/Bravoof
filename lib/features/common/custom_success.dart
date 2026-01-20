import 'dart:ui';

import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSuccess extends StatefulWidget {
  String? title;
  String? bodyText;
  String? b_text1;
  String? b_text2;
  CustomSuccess({
    this.title,
    this.bodyText,
    this.b_text1,
    this.b_text2,
    super.key,
  });

  @override
  State<CustomSuccess> createState() => _CustomSuccessState();
}

class _CustomSuccessState extends State<CustomSuccess> {
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
          child: Container(color: Colors.black.withOpacity(0.2)),
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
                  widget.title.toString(),
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Image.asset("assets/images/mission_win.png", height: 100),
                Text(
                  widget.bodyText.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F5F5F),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                if (widget.b_text1 != "Done")
                  FlowvaButton.whiteButton(
                    name: widget.b_text1!,
                    apply: () {
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
                  name: widget.b_text2 ?? "Done",
                  apply: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
