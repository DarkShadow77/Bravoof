import 'package:Bravoo/features/dashboard/settings/presentation/widgets/connected_device_widget.dart';
import 'package:Bravoo/features/dashboard/settings/presentation/widgets/create_password.dart';
import 'package:Bravoo/features/dashboard/settings/presentation/widgets/deactivate_account.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginAndSecurityScreen extends StatefulWidget {
  const LoginAndSecurityScreen({Key? key}) : super(key: key);

  @override
  State<LoginAndSecurityScreen> createState() => _LoginAndSecurityScreenState();
}

class _LoginAndSecurityScreenState extends State<LoginAndSecurityScreen> {
  bool biometricEnabled = true;

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
          "Login and Security",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          // Logging in section
          const SectionTitle(title: "Logging in"),

          CustomTile(
            title: "Password",
            subtitle: "Not Created",
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 18,
              color: Colors.black54,
            ),
            apply: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                // important for blur
                builder: (_) => CreatePasswordWidget(),
              );
            },
          ),

          const SizedBox(height: 16),

          // Social Accounts
          const SectionTitle(title: "Social Accounts"),
          CustomTile(
            title: "Google",
            subtitle: "Connected",
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 18,
              color: Colors.black54,
            ),
            apply: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                // important for blur
                builder: (_) => ConnectedDeviceWidget(),
              );
            },
          ),

          const SizedBox(height: 16),

          // Account section
          const SectionTitle(title: "Account"),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deactivate your account",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191919),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "This action cannot be undone",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      // important for blur
                      builder: (_) => DeactivateAccountWidget(),
                    );
                  },
                  child: Text(
                    "Deactivate",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB60000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF767676),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  Function() apply;

  CustomTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    required this.apply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191919),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F5F5F),
                ),
              )
            : null,
        trailing: trailing,
        onTap: apply,
      ),
    );
  }
}
