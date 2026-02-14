import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/connect_social_account_modal.dart';
import '../widgets/delete_account_modal.dart';

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
          /*const SectionTitle(title: "Logging in"),

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

          const SizedBox(height: 16),*/
          const SectionTitle(title: "Social Accounts"),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profile = state.profile;
              final socialAccount = profile.providerEmails.linkedSocial;
              final title = socialAccount.isEmpty
                  ? "No Social Account"
                  : socialAccount.join(" ,");
              return OptionTile(
                title: title,
                subtitle: socialAccount.isEmpty
                    ? "Connect your social account"
                    : "Connected",
                onTap: () {
                  connectSocialAccountModal();
                },
              );
            },
          ),
          SizedBox(height: 24.h),
          const SectionTitle(title: "Account"),
          OptionTile(
            title: "Delete your account",
            subtitle: "This action cannot be undone",
            onTap: () {
              deactivateAccountModal();
            },
            trailing: TextButton(
              onPressed: () {
                deactivateAccountModal();
              },
              child: Text(
                "Delete",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB60000),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: title,
                      style: TextStyles.normalBold14(context),
                    ),
                  ),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: subtitle,
                      style: TextStyles.smallMedium12(
                        context,
                      ).copyWith(color: AppColors.grey550),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18.sp,
                  color: AppColors.grey500,
                ),
          ],
        ),
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyles.normalSemibold14(
            context,
          ).copyWith(color: AppColors.grey500),
        ),
      ),
    );
  }
}
