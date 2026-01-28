import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({Key? key}) : super(key: key);

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Legal and Terms",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        children: [
          buildTile(
            HugeIcon(
              icon: HugeIcons.strokeRoundedHelpCircle,
              strokeWidth: 2,
              color: Color(0xFF191919),
              size: 20,
            ),
            "Terms & Conditions",
            trailingIcon: HugeIcons.strokeRoundedLinkSquare01,
            apply: () async {
              final uri = Uri.parse(
                "https://www.joinbravoo.com/terms-and-conditions",
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F1F1)),
          buildTile(
            HugeIcon(
              icon: HugeIcons.strokeRoundedLegalDocument01,
              strokeWidth: 2,
              color: Color(0xFF191919),
              size: 20,
            ),
            "Privacy Policy",
            trailingIcon: HugeIcons.strokeRoundedLinkSquare01,
            apply: () async {
              final uri = Uri.parse(
                "https://www.joinbravoo.com/privacy-policy",
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTile(
    Widget icon,
    String title, {
    Color? iconColor,
    List<List<dynamic>>? trailingIcon,
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
        icon: trailingIcon ?? HugeIcons.strokeRoundedArrowRight01,
        size: 18,
        color: Colors.black54,
      ),
      onTap: apply,
      horizontalTitleGap: 10,
      minVerticalPadding: 20,
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
