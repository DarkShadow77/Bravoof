import 'dart:ui';

import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:Bravoo/features/dashboard/profile/presentation/widgets/edit_profile.dart';
import 'package:Bravoo/features/dashboard/settings/presentation/pages/login_and_security_page.dart';
import 'package:Bravoo/features/onbaording/page/onbaording_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../settings/presentation/pages/help_page.dart';
import '../../../settings/presentation/pages/notifications.dart';

class SettingsPage extends StatelessWidget with UIToolMixin {
  const SettingsPage({super.key});

  Widget buildTile(
    Widget icon,
    String title, {
    Color? iconColor,
    required Future Function() apply,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
      trailing: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        size: 18,
        color: Colors.black54,
      ),
      onTap: apply,
      horizontalTitleGap: 10,
      minVerticalPadding: 20,
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Settings",
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedUserCircle,
                    // color: Colors.black,
                    strokeWidth: 2,
                    size: 20,
                  ),
                  "Personal Information",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => EditProfilePage()),
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedUserShield01,
                    strokeWidth: 2,
                    color: Color(0xFF191919),
                    size: 20,
                  ),
                  "Login & Security",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => LoginAndSecurityScreen(),
                    ),
                  ),
                ),
                // const Divider(height: 1, color: Color(0xFFF1F1F1)),
                // buildTile(
                //   HugeIcon(icon: HugeIcons.strokeRoundedSquareLock01,color: Color(0xFF191919),strokeWidth: 2, size: 20),
                //   "Privacy",
                //   apply: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (ctx) => LoginAndSecurityScreen()),
                //   ),
                // ),
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                buildTile(
                  Image.asset(
                    "assets/images/bell.png",
                    height: 20,
                    color: Colors.black.withOpacity(0.8),
                    fit: BoxFit.fitWidth,
                  ),
                  "Notifications",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => NotificationSettingPage(),
                    ),
                  ),
                ),
                // const Divider(height: 1, color: Color(0xFFF1F1F1)),
                // buildTile(
                //   HugeIcon(icon: HugeIcons.strokeRoundedCreditCard,color: Color(0xFF191919), size: 20),
                //   "Payments and Payouts",
                //   apply: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (ctx) => LoginAndSecurityScreen()),
                //   ),
                // ),
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    strokeWidth: 2,
                    color: Color(0xFF191919),
                    size: 20,
                  ),
                  "Get Help",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => HelpPage()),
                  ),
                ),
                /*  const Divider(height: 1, color: Color(0xFFF1F1F1)),
             buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedLegalDocument01,
                    strokeWidth: 2,
                    color: Color(0xFF191919),
                    size: 20,
                  ),
                  "Legal and Terms",
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => LoginAndSecurityScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),*/
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/images/logout-04.svg",
                    color: Color(0xFF9B0000),
                  ),
                  title: Text(
                    "Log out",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B0000),
                    ),
                  ),
                  onTap: () => showLogoutDialog(context),
                  horizontalTitleGap: 10,
                  minVerticalPadding: 20,
                  contentPadding: EdgeInsets.symmetric(horizontal: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (_) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: AppColors.black50),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    right: 16,
                    left: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Are You sure",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF191919),
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Message text
                      Text(
                        "Continue to log out for now...",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Buttons
                      FlowvaButton.whiteButton(
                        name: "Yes",
                        color: Colors.black,
                        apply: () {
                          context.read<ProfileBloc>().add(LogoutProfileEvent());
                          showMessage(
                            "You've been Logged out",
                            context,
                            color: Colors.green,
                            styleColor: Colors.white,
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OnboardingScreen(),
                            ),
                            (route) => false,
                          );
                          showMessage(
                            "You've been Logged out",
                            context,
                            color: Colors.green,
                            styleColor: Colors.white,
                          );
                        },
                      ),

                      FlowvaButton.blueButton(
                        name: "No",
                        apply: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
