import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/app/view/widgets/gradient_progress.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/utils/helpers.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:flowva/features/dashboard/profile/presentation/pages/profile_page.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../mission/data/bloc/mission_cubit.dart';
import '../../../mission/data/model/rewards_summary_response.dart';
import '../../../mission/presentation/bloc/growth_mission_bloc.dart';
import '../../../mission/presentation/widget/mission_list_title.dart';
import '../../../nav_bar.dart';
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
  UserProfile userProfile = UserProfile.empty();
  late ProfileBloc profileBloc;
  List<Campaign> campaign = [];
  List<RewardsSummary> rewardsSummary = [];

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();
    BlocProvider.of<HomeCubit>(context).fetchCampaigns();
    missionCubit.fetchAllUsersReward();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
    context.read<GrowthMissionBloc>().add(LoadGrowthMission());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
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
              if (state is RewardLoaded) {
                rewardsSummary = state.rewardsSummaryResponse.rewardsSummary!;
                print(rewardsSummary);
                setState(() {});
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                userProfile = state.profile;
              });
            });
            return Container(
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
                                      icon:
                                          HugeIcons.strokeRoundedNotification01,
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
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 0),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 18.h),
                              if (SessionManager().firstTimeUserVal ==
                                  "YES") ...[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                                SessionManager()
                                                        .firstTimeUserVal =
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
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  // padding: const EdgeInsets.all(2),
                                  height: 82.h,
                                  width: double.infinity,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    children: [
                                      // Left Section
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                          ),
                                          child: Column(
                                            spacing: 8.h,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Title + Arrow
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text:
                                                            "More missions await",
                                                        style:
                                                            TextStyles.smallMedium12(
                                                              context,
                                                            ).copyWith(
                                                              color: AppColors
                                                                  .grey200,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${formatAmount(userProfile.totalPoints ?? 0)}",
                                                          style:
                                                              TextStyles.bodySemiBold16(
                                                                context,
                                                              ).copyWith(
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              " / ${formatAmount(userProfile.basePoints ?? 0)}",
                                                        ),
                                                      ],
                                                      style:
                                                          TextStyles.smallMedium12(
                                                            context,
                                                          ).copyWith(
                                                            color: AppColors
                                                                .grey300,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Progress Bar
                                              GradientProgress(
                                                height: 8,
                                                progress:
                                                    (userProfile.totalPoints ??
                                                        0) /
                                                    (userProfile.basePoints ??
                                                        5000),
                                              ),
                                              // Bottom text
                                              if ((userProfile.totalPoints ??
                                                      0) <
                                                  (userProfile.basePoints ?? 0))
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "Just ${(userProfile.basePoints ?? 0) - (userProfile.totalPoints ?? 0)}  more till your next reward! ✨",
                                                    style:
                                                        TextStyles.cardSemibold10(
                                                          context,
                                                        ).copyWith(
                                                          color:
                                                              AppColors.grey200,
                                                        ),
                                                  ),
                                                )
                                              else
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "Congratulations on getting to 5000 coins!!",
                                                    style:
                                                        TextStyles.cardSemibold10(
                                                          context,
                                                        ).copyWith(
                                                          color:
                                                              AppColors.grey200,
                                                        ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Right Section - Circular Rewards
                                      Container(
                                        color: AppColors.white50,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                          horizontal: 12.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/one_50.png",
                                              height: 30,
                                            ),
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: "Redeem",
                                                style:
                                                    TextStyles.normalMedium14(
                                                      context,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            BottomNavBar(
                                                              index: 1,
                                                              missionIndex: 1,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 20,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 9,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF6E4E6),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFE9E9E9,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            28,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "See more",
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                              0xFF020617,
                                                            ),
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
                                      MissionCard(isFull: false),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              rewardsSummary.isNotEmpty &&
                                      rewardsSummary.length > 2
                                  ? TopLeaderBoard(
                                      rewardsSummary: rewardsSummary,
                                    )
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
            );
          },
        ),
      ),
    );
  }

  // Missions state
}
