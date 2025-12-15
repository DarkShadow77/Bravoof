import 'package:flowva/features/app.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_colors.dart';
import 'package:flowva/features/dashboard/profile/presentation/widgets/edit_profile.dart';
import 'package:flowva/features/dashboard/profile/presentation/widgets/share_profile_widget.dart';
import 'package:flowva/features/dashboard/settings/presentation/pages/settings_page.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, this.avatarIndex});

  static const String routeName = "/profilePage";
  int? avatarIndex;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile userProfile = UserProfile();
  late UserCubit userCubit;

  bool init = true;

  @override
  void initState() {
    userCubit = UserCubit();
    userCubit.fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const referralLink = "https://flowva.ref.12419";

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
            onTap: () =>
                Navigator.push(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocListener<UserCubit, UserState>(
          bloc: userCubit,
          listener: (context, state) {
            if (state is UserProfileSuccess) {
              setState(() {
                init = false;
              });

              userProfile = state.userProfile;
            }
          },
          child: init
              ? Container(
            height: 400,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              backgroundColor: Color(0xff828282),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF9013FE),
              ),
              strokeCap: StrokeCap.round,
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Profile Section
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 85,
                width: 85,
                child: Stack(
                  children: [
                    Container(
                      height: 71,
                      width: 71,
                      decoration: BoxDecoration(
                        color: Color(0xFFC0E9FC),
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        userProfile.profilePic!, fit: BoxFit.fill,),
                    ),

                    Positioned(
                      top: 2,
                      // bottom: -13,
                      right: 10,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    EditProfilePage(
                                        userProfile: userProfile
                                    ),
                              ),
                            ).then((v) {
                              print(v);
                              userCubit.fetchUserProfile();
                            }),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.2),
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

              Text(
                userProfile.name.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                userProfile.bio ?? '',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF767676),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            // width: double.infinity,
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
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
                    color: Colors.black.withOpacity(0.08),
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
                    color: Colors.black.withOpacity(0.08),
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
            apply: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        EditProfilePage(
                            userProfile: userProfile
                        ),
                  ),
                ).then((v) {
                  userCubit.fetchUserProfile();
                }),
            name: "Edit Profile",
            color: Colors.black
          ),

        const SizedBox(height: 20),

        // Referral Section

        Container(
          width: double.infinity,
          // height: 220,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFAAA7A7).withOpacity(0.1),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your referral link',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset("assets/images/copy.png"),
                ],
              ),
              SizedBox(height: 8),
              // Referral link pill
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    const ClipboardData(
                      text: 'https://flowva.ref.12419',
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
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
                    children: [
                      Icon(Icons.link, size: 18, color: kPurple),
                      SizedBox(width: 8),
                      Text(
                        'https://flowva.ref.12419',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9013FE),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              FlowvaButton.blueButton(
                name: "Share Referral Link",
                color: Colors.white,
                icon: Image.asset(
                  "assets/images/share.png",
                  color: Colors.white,
                ),
                apply: () =>
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.3),
                      builder: (_) => const ShareProfileWidget(),
                    ),
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
                          'Next Reward :',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1000',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9013FE),
                              ),
                            ),

                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "1 ",
                                    style:
                                    GoogleFonts.manrope(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/1000",
                                    style:
                                    GoogleFonts.manrope(
                                      fontSize: 14,
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
                            borderRadius:
                            BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              minHeight: 8,
                              value: 0.6,
                              // 1 / 10 shown in screenshot
                              backgroundColor: Color(0xFFF1F1F1),
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
                  Row(
                    children: [
                      Text(
                        'You referred',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/user.png"),
                      SizedBox(width: 6),
                      Text(
                        '0',
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
        SizedBox(height: 20),
        Text(
          "Come hang with us...",
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFBFBFC),
                        Color(0xFFDBDDE8),
                      ])
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFF0062E0)
                ),
                child: Image.asset("assets/images/fb.png", fit: BoxFit.fill,),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFBFBFC),
                        Color(0xFFDBDDE8),
                      ])
              ),
              child: Container(


                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFBFBFC),
                          Color(0xFFDBDDE8),
                        ])
                ),
                child: Image.asset(
                  "assets/images/insta.png", fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFBFBFC),
                        Color(0xFFDBDDE8),
                      ])
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black
                ),
                child: Image.asset("assets/images/xx.png"),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFBFBFC),
                        Color(0xFFDBDDE8),
                      ])
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFF0062E0)
                ),
                child: Image.asset("assets/images/linkedin.png"),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFBFBFC),
                        Color(0xFFDBDDE8),
                      ])
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black
                ),
                child: Image.asset("assets/images/tictok.png"),
              ),
            )
          ],
        ),
        SizedBox(height: 20,),
        ],
      ),
    ),)
    ,
    );
  }
}
