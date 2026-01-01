import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/routes.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:flowva/features/dashboard/profile/presentation/pages/profile_page.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/rewards_summary_response.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../nav_bar.dart';
import '../widget/mission_list_title.dart';
import '../widget/referral_widget.dart';
import '../widget/tool_card.dart';
import '../widget/top_leader_board.dart';
import 'notifications.dart';

class FlowvaHomePage extends StatefulWidget {
  const FlowvaHomePage({super.key});

  @override
  State<FlowvaHomePage> createState() => _FlowvaHomePageState();
}

class _FlowvaHomePageState extends State<FlowvaHomePage> with UIToolMixin {
  late MissionCubit missionCubit;
  final sessionManager = SessionManager();
  UserProfile userProfile = UserProfile();
  late ProfileBloc profileBloc;
  List<Mission> missions = [];
  List<Campaign> campaign = [];
  List<RewardsSummary> rewardsSummary = [];

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();
    BlocProvider.of<HomeCubit>(context).fetchCampaigns();
    missionCubit.fetchMission();
    missionCubit.fetchAllUsersReward();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    print(sessionManager.firstTimeUserVal);
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: FlowvaRoute.userCubit),

          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              print(state);
              setState(() {
                campaign = state.campaignResponse.campaign!;
              });
              print(campaign);
            },
          ),
          BlocListener<MissionCubit, MissionState>(
            bloc: missionCubit,
            listener: (context, state) {
              if (state is MissionUpdateLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.black.withOpacity(0.3),
                  builder: (_) => Center(
                    child: Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        backgroundColor: Color(0xff828282),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF9013FE),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                );
              } else if (state is MissionLoaded) {
                // Navigator.pop(context);
                missions = state.missionResponse.mission!;
                missions.reversed;
                setState(() {
                  missions = missions.isNotEmpty
                      ? missions.take(3).toList()
                      : [];
                });
              } else if (state is MissionUpdated) {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(GetProfileEvent());
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  builder: (_) => CustomSuccess(
                    title: "Mission complete!",
                    bodyText: "You’ve earned a reward 💜",
                    b_text1: "💜️ Bravoo? Tell the world ",
                    b_text2: "Explore more missions",
                  ),
                );
              }
              if (state is RewardLoaded) {
                rewardsSummary = state.rewardsSummaryResponse.rewardsSummary!;
                print(rewardsSummary);
                setState(() {});
              }
              if (state is MissionFailed) {
                // Navigator.pop(context);
                showMessage(
                  state.err,
                  context,
                  color: Colors.red,
                  styleColor: Colors.white,
                  status: true,
                );
              }
            },
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home_page_b.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  // Greeting Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hey, ${userProfile.name}!",
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => NotificationsPage(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 20),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedNotification01,
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: userProfile.profilePic != null
                                        ? Image.network(
                                            userProfile.profilePic!,
                                            fit: BoxFit.fill,
                                          )
                                        : Container(),
                                  ),

                                  // Text("Profile",style: GoogleFonts.manrope(
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12,
                                  //   color: Color(0xFF2B2B2B),
                                  // ),),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0),
                      physics: const BouncingScrollPhysics(),

                      children: [
                        SizedBox(height: 18.h),
                        if (SessionManager().firstTimeUserVal == "YES") ...[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              spacing: 4.h,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text:
                                              "Invite your friends to play with you",
                                          style: TextStyles.normalBold14(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          SessionManager().firstTimeUserVal =
                                              "NO";
                                        });
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: SvgPicture.asset(
                                        AssetsSvgIcons.close,
                                        width: 14.r,
                                        height: 14.r,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text:
                                        "Get 1000 coins when you bring in your first 10 friends.",
                                    style: TextStyles.smallMedium12(
                                      context,
                                    ).copyWith(color: AppColors.grey550),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        campaign.isNotEmpty
                            ? ToolCardCarousel(campaign: campaign)
                            : Container(),
                        const SizedBox(height: 20),

                        // Progress bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GestureDetector(
                            child: Container(
                              // padding: const EdgeInsets.all(2),
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.black54,
                                ),

                                color: Color(0xFFAD50FE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Left Section
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          // Title + Arrow
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "More missions await",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xFFE9E9E9),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${userProfile.totalPoints}",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    " / ${userProfile.basePoints}",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Color(0xFFE9E9E9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          // Progress Bar
                                          // Wrap this inside your widget tree
                                          Container(
                                            height: 8,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color(0xFFF1F1F1),
                                            ),

                                            child: Stack(
                                              children: [
                                                FractionallySizedBox(
                                                  widthFactor:
                                                      userProfile.totalPoints! /
                                                      userProfile.basePoints!,
                                                  // progress percentage
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      gradient:
                                                          const LinearGradient(
                                                            colors: [
                                                              Color(0xFFA259FF),
                                                              Color(0xFFDEC4FF),
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Bottom text
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Just ${(userProfile.basePoints)! - (userProfile.totalPoints!)} ",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Color(0xFFE9E9E9),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Coins",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    color: Color(0xFFE9E9E9),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " until your next win ✨",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Color(0xFFE9E9E9),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Right Section - Circular Rewards
                                  Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Image.asset(
                                            'assets/images/dd.png',
                                            fit: BoxFit.cover,
                                            height: 85,
                                          ),
                                        ),
                                      ),
                                      // Your foreground content here
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/one_50.png",
                                              height: 30,
                                            ),
                                            // const SizedBox(height: 2),
                                            Text(
                                              "Redeem",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Growth Missions",
                                      style: GoogleFonts.baloo2(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BottomNavBar(
                                                  index: 1,
                                                  missionIndex: 1,
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(top: 20),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 9,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF6E4E6),
                                                border: Border.all(
                                                  color: Color(0xFFE9E9E9),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                              ),
                                              child: Text(
                                                "See more",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF020617),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: 15,
                                          //   right: 0,
                                          //
                                          //   child: CircleAvatar(
                                          //     radius: 10,
                                          //     backgroundColor: Color(
                                          //       0xFFB60000,
                                          //     ),
                                          //     child: Text(
                                          //       missions.skip(3).toList().length.toString(),
                                          //       style: GoogleFonts.baloo2(
                                          //         fontSize: 14,
                                          //         fontWeight:
                                          //             FontWeight.w700,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Missions list
                                ...missions.map((mission) {
                                  return MissionListTitle(mission: mission);
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        rewardsSummary.isNotEmpty && rewardsSummary.length > 2
                            ? TopLeaderBoard(rewardsSummary: rewardsSummary)
                            : Container(),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ReferralWidget(),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   left: 20,
              //   right: 0,
              //   bottom:
              //       0, // same base as the button so glow sits behind it
              //   child: Center(
              //     child: SizedBox(
              //       width: 100,
              //       height: 60,
              //       child: Stack(
              //         alignment: Alignment.center,
              //         children: [
              //           // Purple soft central glow
              //           Container(
              //             width: 100,
              //             height: 40,
              //             decoration: BoxDecoration(
              //               color: Colors.transparent,
              //               borderRadius: BorderRadius.circular(60),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: const Color(
              //                     0xFF7367F0,
              //                   ).withOpacity(0.5),
              //                   blurRadius: 20,
              //                   spreadRadius: 6,
              //                 ),
              //               ],
              //             ),
              //           ),
              //
              //           // Red/pink subtle offset glow (left side)
              //           Positioned(
              //             left: 0,
              //             right: 20,
              //             child: Container(
              //               width: 120,
              //               height: 60,
              //               decoration: BoxDecoration(
              //                 color: Colors.transparent,
              //                 borderRadius: BorderRadius.circular(60),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: const Color(
              //                       0xFFFF8A80,
              //                     ).withOpacity(0.5),
              //                     blurRadius: 60,
              //                     spreadRadius: 10,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              //
              // // The floating Focus button (on top of the glow)
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 10,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (ctx) => FocusTimerPage(),
              //         ),
              //       );
              //     },
              //     child: Center(
              //       child: Container(
              //         width: 104,
              //         height: 41,
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 12,
              //           vertical: 12,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(16),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withOpacity(0.12),
              //               blurRadius: 10,
              //               offset: const Offset(0, 4),
              //             ),
              //           ],
              //         ),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Focus",
              //               style: GoogleFonts.manrope(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w500,
              //                 color: Color(0xFF191919),
              //               ),
              //             ),
              //             SizedBox(width: 8),
              //             // Icon(Icons.graphic_eq, size: 18),
              //             Icon(Icons.graphic_eq, size: 18),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Missions state
}
