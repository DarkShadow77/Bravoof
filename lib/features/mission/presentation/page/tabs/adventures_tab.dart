import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../dashboard/earn/presentation/pages/jackpot_page.dart';
import '../../../../dashboard/home/presentation/widget/mission_list_title.dart';
import '../../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../bloc/community_mission_bloc.dart';
import '../../bloc/featured_mission_bloc.dart';
import '../../bloc/social_mission_bloc.dart';
import '../../bloc/sponsored_mission_bloc.dart';
import '../../widget/community_mission_card.dart';
import '../../widget/discover_perks.dart';
import '../../widget/featured_card.dart';
import '../../widget/follow_us_card.dart';
import '../../widget/sponsored_card.dart';

class AdventuresTab extends StatefulWidget {
  const AdventuresTab({super.key});

  @override
  State<AdventuresTab> createState() => _AdventuresTabState();
}

class _AdventuresTabState extends State<AdventuresTab> with UIToolMixin {
  final sessionManager = SessionManager();

  bool init = false;
  List<Campaign> campaign = [];
  List<Mission> missions = [];

  int sum = 0;

  late MissionCubit missionCubit;

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();

    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    BlocProvider.of<HomeCubit>(context).fetchCampaigns();
    missionCubit.fetchMission();
    missionCubit.fetchSkillUpChallenge();

    BlocProvider.of<CommunityMissionBloc>(context).add(LoadCommunityMission());
    BlocProvider.of<CommunityMissionBloc>(context).add(LoadCommunityMission());
    BlocProvider.of<SocialMissionBloc>(context).add(LoadSocialMission());
    BlocProvider.of<FeaturedMissionBloc>(context).add(LoadFeaturedMission());
    BlocProvider.of<SponsoredMissionBloc>(context).add(LoadSponsoredMission());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF8F4FF),
      child: MultiBlocListener(
        listeners: [
          BlocListener<MissionCubit, MissionState>(
            bloc: missionCubit,
            listener: (context, state) {
              if (state is MissionUpdateLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.black.withValues(alpha: 0.3),
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
              }
              if (state is MissionLoaded) {
                /*setState(() {
                  init = false;
                });*/
                missions = state.missionResponse.mission!;
                missions.forEach((e) {
                  if (e.completed!) {
                    setState(() {
                      sum += 1;
                    });
                  }
                });
                print(sum);
              }
              if (state is MissionUpdated) {
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
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              print(state);
              setState(() {
                campaign = state.campaignResponse.campaign!;
              });
            },
          ),
        ],
        child: init
            ? Center(
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
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  children: [
                    // COMMUNITY MISSIONS CARD
                    CommunityMissionCard(),
                    const SizedBox(height: 20),
                    campaign.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: ReferCampaign(campaign: campaign),
                          )
                        : Container(),
                    const SizedBox(height: 20),

                    // Growth Missions header
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Your Growth Begins With a Mission',
                              style: GoogleFonts.baloo2(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9013FE),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 59,
                            height: 59,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50.withValues(
                                      alpha: 0.02,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),

                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Transform.rotate(
                                      angle: -0.14 / 2,
                                      child: CircularProgressIndicator(
                                        value: sum / 5,
                                        strokeWidth: 6,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              Color(0xFF9013FE),
                                            ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${sum}/${missions.length}',
                                  style: GoogleFonts.baloo2(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFA87D7D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "You’re building real momentum. Keep going! ",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF767676),
                            ),
                          ),
                          // Circular progress + text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              // Unlock spins card (mini)
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => JackpotScreen(),
                                  ),
                                ),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withValues(alpha: 0.5),
                                    border: Border.all(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.03,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unlock spins by completing missions',
                                              style: GoogleFonts.manrope(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF2B2B2B),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            // thin progress bar
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: LinearProgressIndicator(
                                                value:
                                                    0 /
                                                    (missions.length == 0
                                                        ? 1.0
                                                        : missions.length),
                                                minHeight: 8,
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF8A3BFF)),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '1 spin available, go to jackpot',
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF6B16CA),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // small wheel icon card
                                      const SizedBox(width: 10),

                                      Container(
                                        width: 60,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.04,
                                              ),
                                              blurRadius: 10,

                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Purple soft central glow
                                                    Positioned(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 0,
                                                      // same base as the button so glow sits behind it
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 100,
                                                          height: 44,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              // Purple soft central glow
                                                              Container(
                                                                width: 80,
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .transparent,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        60,
                                                                      ),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color:
                                                                          const Color(
                                                                            0xFF7367F0,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.5,
                                                                          ),
                                                                      blurRadius:
                                                                          4,
                                                                      spreadRadius:
                                                                          3,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              // Red/pink subtle offset glow (left side)
                                                              Positioned(
                                                                left: 0,
                                                                right: 20,
                                                                child: Container(
                                                                  width: 120,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          60,
                                                                        ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color:
                                                                            const Color(
                                                                              0xFFFF8A80,
                                                                            ).withValues(
                                                                              alpha: 0.5,
                                                                            ),
                                                                        blurRadius:
                                                                            25,
                                                                        spreadRadius:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    // The floating Focus button (on top of the glow)
                                                    Positioned(
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 10,
                                                      child: Image.asset(
                                                        "assets/images/spin.png",
                                                        fit: BoxFit.contain,
                                                        height: 24,
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Text(
                                              //   'x1',
                                              //   style: GoogleFonts.baloo2(
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeight.w700,
                                              //     color: Colors.black.withValues(alpha:0.34),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          ...missions.map((mission) {
                            return MissionListTitle(mission: mission);
                          }).toList(),

                          const SizedBox(height: 40),
                          Text(
                            "“Your growth is happening, even in small moments...”",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.baloo2(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withValues(alpha: 0.25),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SponsoredCard(),
                    SizedBox(height: 20.h),
                    FollowUsCard(),
                    SizedBox(height: 20.h),
                    FeaturedCard(),
                    SizedBox(height: 40.h),
                    DiscoverPerks(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }
}

class MissionTile extends StatelessWidget {
  final Mission mission;
  final VoidCallback onClaim;

  const MissionTile({required this.mission, required this.onClaim, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        color: mission.completed! ? Color(0xFFF6FDF5) : Color(0xFFF6FDF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          mission.icon,
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    mission.title!,
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: mission.id == "rate"
                          ? Colors.black.withValues(alpha: 0.24)
                          : Colors.black.withValues(alpha: 0.50),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                mission.completed!
                    ? Image.asset("assets/images/mark.png")
                    : Container(),
                // : Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15),
                //     child: Stack(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(12),
                //           child: Stack(
                //             children: [
                // //               // Background color (track)
                //               Container(
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                   color: Color(0xFFF1F1F1),
                //                   gradient: LinearGradient(
                //                     begin: Alignment.topCenter,
                //                     end: Alignment.bottomCenter,
                //                     colors: [
                //                       const Color(0xFFD9AEFF),
                //                       const Color(0xFF550AA9),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //
                //               // Gradient progress bar
                //               LayoutBuilder(
                //                 builder: (context, constraints) {
                //                   return Container(
                //                     height: 16,
                //                     width:
                //                         constraints.maxWidth *
                //                         mission.progress!,
                //                     // width proportional to value
                //                     decoration: BoxDecoration(
                //                       color: Color(0xFFF1F1F1),
                //                       gradient: LinearGradient(
                //                         begin: Alignment.topCenter,
                //                         end: Alignment.bottomCenter,
                //                         colors: [
                //                           const Color(0xFFD9AEFF),
                //                           const Color(0xFF550AA9),
                //                         ],
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //         Positioned(
                //           left: 50,
                //           right: 50,
                //           top: -1,
                //
                //           child: Center(
                //             child: Text(
                //               progressTextFromValue(mission.progress!),
                //               style: GoogleFonts.baloo2(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w700,
                //                 color: Colors.white.withValues(alpha:0.42),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
            // height: 80,
            width: 88,
            decoration: BoxDecoration(
              color: mission.completed!
                  ? Color(0xFFF1F1F1)
                  : Color(0xFF9013FE).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mission.id == null
                        ? Image.asset(mission.rightIcon!, height: 22)
                        : Image.network(mission.rightIcon!, height: 22),
                    SizedBox(width: 5),
                    Text(
                      "${mission.points}",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withValues(alpha: 0.34),
                      ),
                    ),
                  ],
                ),

                // SizedBox(height: 5),
                // const SizedBox(height: 10),
                FlowvaButton.purpleButton(
                  color: mission.completed! ? Colors.grey : null,
                  name: "${mission.subject}",
                  apply: onClaim,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
