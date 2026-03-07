import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_enum.dart';

class FlowvaButton {
  static Widget blueButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 18,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/black_button.png",
                fit: BoxFit.contain,
                height: 48,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                SizedBox(width: 8),
                Center(
                  child: buttonState == AppButtonState.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: isTapped ? Color(0xFF999999) : color,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget noneOutlineBlackButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/none_outline_black_button.png",
                  fit: BoxFit.contain,
                  height: 48,
                ),
              ),
            ),
            Positioned.fill(top: 20, child: icon ?? Container()),
            SizedBox(width: 8),
            Center(
              child: buttonState == AppButtonState.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: isTapped ? Color(0xFF999999) : color,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget transparentButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/transparent_button.png",
                fit: BoxFit.contain,
                height: 48,
              ),
            ),
            Positioned.fill(top: 20, child: icon ?? Container()),
            SizedBox(width: 8),
            Center(
              child: buttonState == AppButtonState.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: isTapped ? Color(0xFF999999) : color,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget winnerButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/winner_button.png",
                fit: BoxFit.scaleDown,
                // height: 48,
              ),
            ),

            Positioned(
              top: 25,
              bottom: 0,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isTapped ? Color(0xFF999999) : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget shortBallBlackButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? bColor,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 50,
        // width: 80,
        // width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/short_button.png",
                fit: BoxFit.fill,
                color: bColor,
              ),
            ),
            Positioned.fill(top: 20, child: icon ?? Container()),
            SizedBox(width: 8),
            Center(
              child: buttonState == AppButtonState.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: isTapped ? Color(0xFF999999) : color,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget ballButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (apply != null) apply();
      },
      child: SizedBox(
        height: 48, // smaller height
        width: 48, // fixed width for circular button
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/round_button.png",
                fit: BoxFit.cover,
              ),
            ),
            if (icon != null) icon,
          ],
        ),
      ),
    );
  }

  static Widget subButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: Container(
        height: 40,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/sub_button.png",
                  colorBlendMode: BlendMode.srcIn,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                SizedBox(width: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget mediumBlackButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/medium_black_button.png",
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),
            Positioned.fill(
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Container(child: icon ?? Container()),
                ],
              ),
            ),
            // SizedBox(width: 8),
            // Positioned.fill(top: 20, child: icon ?? Container()),
          ],
        ),
      ),
    );
  }

  static Widget mediumBlack2Button({
    String name = '',
    Function? apply,
    Widget? icon,
    double fontSize = 10,
    Color? color = Colors.white,
    Color? button_bg,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    print(buttonState == AppButtonState.loading);
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/mediumblack2.png",
                color: button_bg,
                fit: BoxFit.scaleDown,
              ),
            ),
            Center(
              child:  buttonState == AppButtonState.loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            SizedBox(width: 8),
            Positioned.fill(top: 20, child: icon ?? Container()),
          ],
        ),
      ),
    );
  }
  static Widget mediumWhiteButton({
    String name = '',
    Function? apply,
    Widget? icon,
    double fontSize = 10,
    Color? color = Colors.white,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/medium_white.png",
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.scaleDown,
              ),
            ),
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            SizedBox(width: 8),
            Positioned.fill(top: 20, child: icon ?? Container()),
          ],
        ),
      ),
    );
  }
  static Widget whiteButton({
    String name = '',
    double spaceBetween = 8,
    Function? apply,
    Widget? icon,
    bool isTapped = false,
    required Color color,
    Color? buttonColor,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/white_button.png",
                color: buttonColor,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                SizedBox(width: spaceBetween),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget greenButton({
    String name = '',
    Function? apply,
    Widget? icon,
    bool isTapped = false,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/green_button.png",

                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget jackpotButton({
    String name = '',
    Function? apply,
    Widget? icon,
    bool isTapped = false,
    Color? buttonColor,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: Container(
        height: 80,
        // width: double.infinity,
        // color:buttonColor!=null? buttonColor.withValues(alpha:0.8):null,
        child: Stack(
          // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/jackpot_button.png",

                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.scaleDown,
                color: buttonColor ?? null,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: buttonColor ?? null,
                  child: icon ?? Container(),
                ),
                // SizedBox(width: 90),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget shortBlackButtonWithOuline({
    String name = '',
    Function? apply,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80, // Set the height to match your button image
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/short_button_with_outline.png",
                color: isTapped ? Colors.purple : null,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            SizedBox(
              // height: 55,
              height: 20,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget shortBlackButtonNoOutline({
    String name = '',
    Function? apply,
    bool isTapped = false,
    bool isActive = false,
    Color? buttonColor

  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 50, // Set the height to match your button image
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/short_button.png",
                // color: isTapped ? Colors.purple : null,//old
                color:isActive?null:buttonColor ,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
                // height: 50,
              ),
            ),
            SizedBox(
              height: 40,
              // height: 20,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget shortInactiveButton({
    String name = '',
    Function? apply,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80, // Set the height to match your button image
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/short_inactive_button.png",
                fit: BoxFit.contain,
height: 80,

              ),
            ),
            SizedBox(
              // height: 55,
              // height: 20,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget arrowShortWhiteButton({
    Function? apply,
    Widget? icon,

    required Color color,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/short_white_with_icon.png",

                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),

            Center(child: icon ?? Container()),
          ],
        ),
      ),
    );
  }

  static Widget shortWhiteButton({
    String name = '',
    Function? apply,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 100, // Set the height to match your button image
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/get_reward.png",
                color: isTapped ? Colors.purple : null,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 55,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget purpleButton({
    String name = '',
    Function? apply,
    bool isTapped = false,
    Color? color
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/purple_button.png",
                // width: 120,
                // height: 100,
                colorBlendMode: BlendMode.srcIn,
                color: color,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Widget successPurpleButton({
    String name = '',
    Function? apply,
    bool isTapped = false,
    Color? color
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/success_purple_button.png",
                // width: 120,
                // height: 100,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              height: 30,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget purple_Button({
    String name = '',
    Function? apply,
    bool isTapped = false,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: Container(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/purple_bg.png",

                // colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 20,
              right: 50,
              left: 50,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget inactiveButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/inactive_button.png",
                fit: BoxFit.fill,
                // height: 48,
              ),
            ),
            Positioned.fill(top: 20, child: icon ?? Container()),
            SizedBox(width: 8),
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isTapped ? Color(0xFF999999) : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Widget inActiveButton({
    String name = '',
    Function? apply,
    Widget? icon,
    Color? color = Colors.white,
    double fontSize = 16,
    bool isTapped = false,
    AppButtonState buttonState = AppButtonState.idle,
  }) {
    return GestureDetector(
      onTap: () => {if (apply != null) apply()},
      child: Container(
        height: 35,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          alignment: Alignment.center, // Center everything inside
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/in_active_b.png",
                fit: BoxFit.fill,
                // height: 48,
              ),
            ),

            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isTapped ? Color(0xFF999999) : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
