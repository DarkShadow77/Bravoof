import 'package:flowva/app/view/widgets/cached_image_widget.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_colors.dart';
import 'package:flowva/features/dashboard/profile/presentation/widgets/edit_profile.dart';
import 'package:flowva/features/dashboard/settings/presentation/pages/settings_page.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../earn/presentation/pages/invite_earn.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, this.avatarIndex});

  static const String routeName = "/profilePage";
  int? avatarIndex;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile userProfile = UserProfile();
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 25),
              ),
              SizedBox(width: 8),
              Text(
                "Profile",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 120,
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => SettingsPage()),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings01,
                strokeWidth: 2.5,
                size: 25,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          userProfile = state.profile;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Container(
                  height: 85,
                  width: 85,
                  child: Stack(
                    children: [
                      CachedImageRadius(
                        imageUrl: userProfile.profilePic ?? "",
                        size: 71.r,
                        circle: true,
                        fit: BoxFit.fill,
                        color: AppColors.grey300.withValues(alpha: .5),
                      ),
                      Positioned(
                        top: 2,
                        // bottom: -13,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => EditProfilePage(),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.2),
                              ),
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedEdit03,
                              strokeWidth: 2.5,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // top: 10,
                        bottom: -5,
                        right: 4,
                        child: Image.asset(
                          "assets/images/badge.png",
                          height: 42,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: userProfile.name.toString(),
                    style: TextStyles.bodySemiBold16(context),
                  ),
                ),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: userProfile.bio ?? '',
                    style: TextStyles.smallMedium12(context, opacity: .5),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  // width: double.infinity,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(
                          colors: [Color(0xFF9013FE), Color(0xFFFF8687)],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    blendMode: BlendMode.srcIn,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Top 24 on Global Leaderboard",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9013FE),
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowUpRight03,

                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          userProfile.totalPoints.toString(),
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9013FE),
                          ),
                        ),
                        Text(
                          "Coins",
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA5A5A5),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "0",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Mission completed",
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA5A5A5),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "0",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Followers",
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA5A5A5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FlowvaButton.whiteButton(
                  apply: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => EditProfilePage()),
                  ),
                  name: "Edit Profile",
                  color: Colors.black,
                ),

                const SizedBox(height: 20),

                // Referral Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: referralMessage(userProfile.referralCode ?? ""),
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 8.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Your Referral Code',
                                style: TextStyles.bodyMedium16(context),
                              ),
                            ),
                            SvgPicture.asset(
                              AssetsSvgIcons.copy,
                              height: 12.r,
                              width: 12.r,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Referral link pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 12.h,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: kBackground,
                                  borderRadius: BorderRadius.circular(28.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kPurple.withValues(alpha: 0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  spacing: 8.w,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.link,
                                      size: 18.sp,
                                      color: kPurple,
                                    ),
                                    Flexible(
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text:
                                              'https://app.joinbravoo.com?ref=${userProfile.referralCode}',
                                          style: TextStyles.normalSemibold14(
                                            context,
                                          ).copyWith(color: AppColors.primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
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
                                name: "Share Referral Code",
                                color: Colors.white,
                                icon: Image.asset(
                                  "assets/images/share.png",
                                  color: Colors.white,
                                ),
                                apply: () {
                                  SharePlus.instance.share(
                                    ShareParams(
                                      text: referralMessage(
                                        userProfile.referralCode ?? "",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              // Progress row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // coin circle
                                  Image.asset(
                                    "assets/images/one_50.png",
                                    height: 50,
                                  ),
                                  const SizedBox(width: 12),
                                  // center column with next unlock and progress
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${userProfile.referralCount}",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 16,
                                                      color: kPurple,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "/10",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: LinearProgressIndicator(
                                              minHeight: 8,
                                              value:
                                                  userProfile.referralCount! /
                                                  10, // 1 / 10 shown in screenshot
                                              backgroundColor: kLightGray,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    kPurple,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // right fraction
                                ],
                              ),
                              SizedBox(height: 20),
                              // you referred row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'You referred',
                                      style: TextStyles.normalSemibold14(
                                        context,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset("assets/images/user.png"),
                                      SizedBox(width: 6.w),
                                      RichText(
                                        text: TextSpan(
                                          text: "${userProfile.referralCount}",
                                          style: TextStyles.bodySemiBold16(
                                            context,
                                          ),
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
                SizedBox(height: 20),
                Text(
                  "Come hang with us...",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF0062E0),
                        ),
                        child: Image.asset(
                          "assets/images/fb.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                        ),
                      ),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                          ),
                        ),
                        child: Image.asset(
                          "assets/images/insta.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black,
                        ),
                        child: Image.asset("assets/images/xx.png"),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF0062E0),
                        ),
                        child: Image.asset("assets/images/linkedin.png"),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFBFBFC), Color(0xFFDBDDE8)],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black,
                        ),
                        child: Image.asset("assets/images/tictok.png"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
