import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_colors.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/badge_page.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



class ReferralPage extends StatelessWidget {
  UserProfile? userProfile;
   ReferralPage( {super.key,required this.userProfile });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [



        // Big invite card / illustration
        Container(
          height: 220,
          // color: Colors.red,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/invite_bg.png",
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      "assets/images/gift_bag.png",
                      height: 67,
                    ),
                  ),
                  SizedBox(height: 16),
                  Image.asset("assets/images/logo.png", height: 30),
                  SizedBox(height: 8),
                  Text(
                    'Invite and Earn',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            'Every friend counts: Get 50 Coins each when your friend checks in for the first time.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5F5F5F),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Referral card
        Container(
          width: double.infinity,
          height: 330,
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: (){
              Clipboard.setData(
                ClipboardData(text: 'https://app.flowvahub.com?ref=${userProfile!.referralCode}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Referral link copied to clipboard!'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Referral Link',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      "assets/images/copy.png"),
                  ],
                ),
                SizedBox(height: 8),
                // Referral link pill
                Container(
                  width: 270,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: kPurple.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.link, size: 18, color: kPurple),
                      SizedBox(width: 8),
                      Text(
                        'https://app.flowvahub.com?ref=${userProfile!.referralCode}',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: kPurple,
                        ),

                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      FlowvaButton.blueButton(
                        name: "Invite friends",
                        color: Colors.white,
                        icon: Icon(Icons.person_add_alt_1,color: Colors.white),
                        apply: ()=>Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InviteAndEarnPage()))
                      ),
                      const SizedBox(height: 20),
                      // Progress row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // coin circle
                          Image.asset("assets/images/one_50.png", height: 50),
                          const SizedBox(width: 12),
                          // center column with next unlock and progress
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First 10 referrals :',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   "${userProfile!.referralCount}",
                                    //   style: GoogleFonts.manrope(
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w700,
                                    //     color: kPurple,
                                    //   ),
                                    // ),

                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${userProfile!.referralCount}",
                                            style: GoogleFonts.manrope(
                                              fontSize: 16,
                                              color: kPurple,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "/1000",
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value:userProfile!.referralCount!/10, // 1 / 10 shown in screenshot
                                      backgroundColor: kLightGray,
                                      valueColor: AlwaysStoppedAnimation(kPurple),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // right fraction
                        ],
                      ),
                      SizedBox(height: 25),
                      // you referred row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'You referred',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children:  [
                              Image.asset("assets/images/user.png"),
                              SizedBox(width: 6),
                              Text(
                                "${userProfile!.referralCount}",
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF191919),
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
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // small helper that builds each curated tile
  Widget curatedTile(String label, Widget icon) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 78,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 74,
              height: 78,
              decoration: BoxDecoration(
                color: kLightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,

                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191919),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// the color is clean  will use later
// Container(
// width: 72,
// height: 72,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(12),
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.04),
// blurRadius: 10,
// offset: const Offset(0, 6),
// )
// ],
// ),
// child: Center(
// child: Container(
// width: 44,
// height: 44,
// decoration: BoxDecoration(
// color: Color(0xFFF1F1F6),
// borderRadius: BorderRadius.circular(10),
// ),
// child: Center(child: Icon(icon, color: kPurple, size: 22)),
// ),
// ),
// ),
