import 'package:flowva/app/view/widgets/cached_image_widget.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/utils/helpers.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/profile/presentation/pages/settings_page.dart';
import 'package:flowva/features/dashboard/profile/presentation/widgets/edit_profile.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../home/presentation/widget/referral_widget.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  static const String routeName = "/profilePage";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile userProfile = UserProfile.empty();
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
  }

  List<Map<String, dynamic>> socials = [
    {
      "image": AssetsPngImages.socialFacebook,
      "url": "https://www.facebook.com/share/17aaV2imwV/?mibextid=wwXIfr",
      "name": "Facebook",
    },
    {
      "image": AssetsPngImages.socialInstagram,
      "url":
          "https://www.instagram.com/joinbravoo?igsh=MXE0cGsyMnRzc3FpeQ%3D%3D&utm_source=qr",
      "name": "Instagram",
    },
    {
      "image": AssetsPngImages.socialTwitter,
      "url": "https://x.com/flowvahub?s=21",
      "name": "Twitter(x)",
    },
    {
      "image": AssetsPngImages.socialLinkedin,
      "url": "https://www.linkedin.com/company/flowva/",
      "name": "LinkedIn",
    },
    {
      "image": AssetsPngImages.socialTik_tok,
      "url": "https://www.tiktok.com/@joinbravoo?_r=1&_t=ZS-92w1Hqj0gUP",
      "name": "Tiktok",
    },
  ];

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
                            "Top 24 on Leaderboard",
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
                          formatAmount(userProfile.totalPoints ?? 0),
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
                          formatAmount(userProfile.missionsCompleted ?? 0),
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
                          "Certificates",
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
                SizedBox(height: 20.h),
                // Referral card
                ReferralCard(),
                SizedBox(height: 20.h),
                Text(
                  "Come hang with us...",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 18.w,
                  runSpacing: 10.h,
                  children: socials.map((e) {
                    return GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(e["url"]);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: Image.asset(
                        e["image"],
                        width: 46.77.r,
                        height: 46.77.r,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
