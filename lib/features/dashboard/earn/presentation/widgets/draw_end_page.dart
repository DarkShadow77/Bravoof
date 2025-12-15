import 'dart:ui';

import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/delivery_address.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/pedestal_with_product.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/social_media_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class DrawEndPage extends StatefulWidget {
  const DrawEndPage({super.key});

  @override
  State<DrawEndPage> createState() => _DrawEndPageState();
}

class _DrawEndPageState extends State<DrawEndPage> {
  bool onClick = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F1C48), // deep purple background
      body: ListView(
        padding: EdgeInsets.only(bottom: 10),
        children: [
          SizedBox(height: 60),
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
                Expanded(
                  child: Text(
                    "The draw has end",
                    style: GoogleFonts.baloo2(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Centered Product Image
          Container(
            decoration: BoxDecoration(),
            child: Image.asset(
              "assets/images/tt.png",
              height: 120,
              // fit: BoxFit.c,
            ),
          ),

          // Center(
          //   child: PedestalWithProduct(
          //       position: 1,
          //       height: 140,
          //       color: Color(0xFF7B24E8),
          //
          //   )
          // ),
          Container(
            // color: Colors.red,
            height: 395,
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Timer container (3D effect card)
                Positioned.fill(
                  top: -10,
                  left: 0,
                  right: 0,
                  bottom: 235,
                  child: Container(
                    child: Image.asset("assets/images/pedestal.png"),
                  ),
                ),
                Positioned.fill(
                  top: -10,
                  left: 0,
                  right: 0,
                  bottom: 310,
                  child: Container(
                    child: Image.asset("assets/images/the_end.png"),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 230),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          // Color(0xFF2F1C48),
                          Colors.white.withOpacity(0.02),
                          Color(0xFF2F1C48),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E0540).withOpacity(0.06),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 20)
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF4F396A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF4F396A),
                          Color(0xFF3E2E56).withOpacity(0.2),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFAAA7A7).withOpacity(0.09),
                          offset: const Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        RichText(
                          textAlign:TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.42), // default color
                            ),
                            children: [
                              const TextSpan(text: "The Oraimo Opensnap Airpod goes to "),
                              TextSpan(
                                text: "@Amaka!",
                                style: const TextStyle(
                                  color: Colors.white, // make @Amaka! pure white
                                ),
                              ),
                              const TextSpan(
                                text:
                                " You didn’t win this time, but the next one could be yours.",
                              ),
                            ],
                          ),
                        ),

                        FlowvaButton.winnerButton(
                          name: "Collect Points & Badge",
                        ),
                        Text(
                          "DRAW ENDS IN",
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.42),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Countdown timer boxes
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _timeBox("00", "DAYS"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/_.svg',
                                color: Colors.white,
                              ),
                            ),
                            _timeBox("00", "HRS"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/_.svg',
                                color: Colors.white,
                              ),
                            ),
                            _timeBox("00", "MIN"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/_.svg',
                                color: Colors.white,
                              ),
                            ),
                            _timeBox("00", "SEC"),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stats text
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                LinearGradient(
                                  colors: [Colors.white, Color(0xFF999999)],
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            blendMode: BlendMode.srcIn,
                            child: Center(
                              child: Text(
                                "5600 users entered IN TOTAL",
                                style: GoogleFonts.baloo2(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Qualification Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Color(0xFF3E2E56),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                //#2C0066
                BoxShadow(
                  color: Color(0xFFAAA7A7).withOpacity(0.9),
                  offset: const Offset(0, 0),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset("assets/images/mic2.png", fit: BoxFit.cover),
                const SizedBox(height: 8),
                Text(
                  "QUALIFICATION RULE",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Invite at least 2 friends who sign up through your link to qualify.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Invite button
                Container(
                  padding: EdgeInsets.only(bottom: 10, right: 16, left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFAAA7A7).withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // onClick
                      //     ?
                      FlowvaButton.greenButton(
                        color: Colors.white,
                        // buttonColor: Color(0xFF008753),
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        name: "You've Entered",

                        apply: () {
                          setState(() {
                            onClick = true;
                          });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (ctx) => InviteAndEarnPage(),
                          //   ),
                          // );
                        },
                      ),

                      // :
                      // FlowvaButton.greenButton(
                      //         color: Colors.white,
                      //         // buttonColor: Color(0xFF008753),
                      //         icon: Icon(
                      //           Icons.check_circle,
                      //           color: Colors.white,
                      //         ),
                      //         name: "Invite Friends Now",
                      //         apply: () {
                      //           setState(() {
                      //             onClick = false;
                      //           });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) =>
                      //         DeliveryAddressScreen(),
                      //   ),
                      // );
                      // },
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset("assets/avatar/2.png"),
                            ),

                            const SizedBox(width: 12),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedUser03,
                              color: Colors.white.withOpacity(0.2),
                              strokeWidth: 0.5,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "Once your second friend joins, you're automatically entered.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Divider(color: Colors.white.withOpacity(0.1)),

                      const SizedBox(height: 16),

                      // Referral link
                      Text(
                        "Invite your friends quick & easy.",
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "https://flowva.ref.12419",
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Social share buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaCards(
                            color: Colors.white.withOpacity(0.24),
                            textColor: Colors.white70,
                            icon: Image.asset("assets/images/whatsapp.png"),
                            label: "Whatsapp",
                          ),
                          const SizedBox(width: 16),
                          SocialMediaCards(
                            color: Colors.white.withOpacity(0.24),
                            textColor: Colors.white70,
                            icon: Image.asset("assets/images/x.png"),
                            label: "X (Twitter)",
                          ),
                          const SizedBox(width: 16),
                          SocialMediaCards(
                            color: Colors.white.withOpacity(0.24),
                            textColor: Colors.white70,
                            icon: Image.asset("assets/images/linkedin.png"),
                            label: "LinkedIn",
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "You referred ",
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.person_2_rounded, color: Colors.white),
                              Text(
                                '1',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Countdown box widget
  Widget _timeBox(String value, String label) {
    return Container(
      width: 67,
      height: 67,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 10,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class WinnerDailog extends StatelessWidget {
  const WinnerDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 36,
                    width: 36,
                    margin: EdgeInsets.only(left: 40, top: 30, bottom: 30),

                    decoration: BoxDecoration(
                      // color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),

                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [
                          Color(0xFFFAD961), // light yellow
                          Colors.white, // white middle
                          Color(0xFFFAD961), // light yellow again
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'You did it James!',
                    style: GoogleFonts.baloo2(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "You’re this Month’s winner",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset("assets/images/winner_package.png"),
                SizedBox(height: 20),
                FlowvaButton.winnerButton(name: "Claim Reward"),

                Text(
                  "Your consistency, curiosity, and Flowva spirit just paid off. Enjoy your Oraimo Boomsnap + 500 FlowCoins!",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
