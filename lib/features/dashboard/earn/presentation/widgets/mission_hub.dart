import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_status_enum.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/social_trivia_response.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../onbaording/data/bloc/user_cubit.dart';
import '../../bloc/community_mission_bloc.dart';
import '../../bloc/featured_mission_bloc.dart';
import '../../bloc/social_mission_bloc.dart';
import '../../bloc/sponsored_mission_bloc.dart';
import '../../data/models/community_mission_model.dart';
import '../pages/jackpot_page.dart';
import 'claim_widget.dart';
import 'discover_perks.dart';
import 'featured_card.dart';
import 'follow_us_card.dart';
import 'sponsored_card.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({super.key});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> with UIToolMixin {
  int currentPage = 0;
  int selectedIndex = 0;
  final _scrollController = PageController(viewportFraction: 1);
  final sessionManager = SessionManager();
  int userGoal = 5000;
  bool init = false;
  bool isInstagramCompleted = true;
  bool isPerkCompleted = false;
  List<Campaign> campaign = [];
  List<Mission> missions = [];
  List<SocialTrivia> socialTrivia = [];

  final int targetUsers = 5000;
  int sum = 0;

  late MissionCubit missionCubit;

  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );
  int differenceInSeconds = 0;

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();

    BlocProvider.of<HomeCubit>(context).fetchCampaigns();
    missionCubit.fetchMission();
    missionCubit.fetchSkillUpChallenge();

    final userCubit = UserCubit();
    userCubit.updateUserProfile();
    BlocProvider.of<CommunityMissionBloc>(context).add(LoadCommunityMission());
    BlocProvider.of<SocialMissionBloc>(context).add(LoadSocialMission());
    BlocProvider.of<FeaturedMissionBloc>(context).add(LoadFeaturedMission());
    BlocProvider.of<SponsoredMissionBloc>(context).add(LoadSponsoredMission());
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
              if (state is SocialMissionLoaded) {
                socialTrivia = state.socialTriviaResponse.socialTrivia!;
                socialTrivia.forEach((e) {
                  if (e.title!.toLowerCase() == "perks mission" &&
                      e.completed!) {
                    isPerkCompleted = e.completed!;
                  }
                  if (e.title!.toLowerCase() == "reclaim mission" &&
                      e.completed!) {}
                });
                setState(() {});
                print("isPerkCompleted");
                print(isPerkCompleted);
                print("isPerkCompleted");
              }
              if (state is MissionUpdated) {
                Navigator.pop(context);
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
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    // COMMUNITY MISSIONS CARD
                    BlocBuilder<CommunityMissionBloc, CommunityMissionState>(
                      builder: (context, state) {
                        CommunityMission? communityMission = state.mission;

                        final now = DateTime.now().toUtc();
                        differenceInSeconds =
                            (communityMission?.endDate ?? DateTime.now())
                                .toUtc()
                                .difference(now)
                                .inSeconds
                                .clamp(0, double.infinity)
                                .toInt();

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                children: [
                                  // Card top section
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFEFEF),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: EdgeInsets.only(
                                      top: 16,
                                      left: 16,
                                      right: 16,
                                      bottom: 22,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Community Missions",
                                          style: GoogleFonts.baloo2(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24,
                                            color: Color(0xFF70403E),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFF9013FE,
                                            ).withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 20,
                                                  horizontal: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/reclaim_rec.png',
                                                  height: 60,
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/mission_10.png',
                                                      height: 80,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Image.asset(
                                                      'assets/images/mission_pro.png',
                                                      height: 80,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/one_50.png',
                                                          width: 50,
                                                        ),
                                                        Text(
                                                          "250,000",
                                                          style:
                                                              GoogleFonts.baloo2(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                                color: Color(
                                                                  0xFFA259FF,
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          communityMission?.title ?? "",
                                          style: GoogleFonts.baloo2(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  // Card bottom section
                                  _buildTimeLeftContainer(context),
                                ],
                              ),
                              Positioned(
                                top: 225,
                                // Adjust this to position correctly between the cards
                                left: 100,
                                // Horizontal position of left stroke
                                child: strokeConnector(),
                              ),
                              Positioned(
                                top: 225,
                                right:
                                    100, // Horizontal position of right stroke
                                child: strokeConnector(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: MissionTile(
                                mission: mission,
                                onClaim: () async {
                                  if (!mission.completed! &&
                                      mission.subject!.toLowerCase() ==
                                          "watch") {
                                    final Uri _url = Uri.parse(
                                      'https://www.youtube.com/watch?v=s7NG1PZaRCE',
                                    );
                                    if (!await launchUrl(
                                      _url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception('Could not launch $_url');
                                    }
                                    setState(() {
                                      mission.completed = true;
                                    });
                                    missionCubit.updateReward({
                                      "mission_id": mission.id,
                                      "name": mission.subject,
                                      "reward_title": mission.title,
                                      "points": mission.points,
                                      "user_id": sessionManager.userIdVal,
                                      "email": sessionManager.userEmailval,
                                      "completed": mission.completed,
                                    });
                                    // var d = jsonEncode([
                                    //   {
                                    //     "completed": mission.completed,
                                    //     "id": mission.id,
                                    //   },
                                    // ]);
                                    // sessionManager.missionVal = d;
                                  }
                                  if (!mission.completed! &&
                                      mission.subject!.toLowerCase() ==
                                          "rate us") {
                                    final Uri _url = Uri.parse(
                                      'https://play.google.com/store/apps/details?id=com.softAlliance.softsuite.org&pli=1',
                                    );
                                    if (!await launchUrl(
                                      _url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception('Could not launch $_url');
                                    }
                                    setState(() {
                                      mission.completed = true;
                                    });

                                    missionCubit.updateReward({
                                      "mission_id": mission.id,
                                      "name": mission.subject,
                                      "reward_title": mission.title,
                                      "points": "0",
                                      "number_of_spins": 1,
                                      "user_id": sessionManager.userIdVal,
                                      "email": sessionManager.userEmailval,
                                      "completed": mission.completed,
                                    });

                                    // var d = sessionManager.missionVal.isNotEmpty
                                    //     ? jsonDecode(sessionManager.missionVal)
                                    //     : [];
                                    // var e = jsonEncode([
                                    //   {
                                    //     "completed": mission.completed,
                                    //     "id": mission.id,
                                    //   },
                                    // ]);
                                    // d.add(e);
                                    // sessionManager.missionVal = e;
                                  }
                                  if (mission.subject!.toLowerCase() ==
                                      "invite")
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => InviteAndEarnPage(),
                                      ),
                                    );
                                  // _claimMission(idx);
                                },
                              ),
                            );
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

  List<String> formattedTime2(double time) {
    final int days = (time / 86400).floor(); // 1 day = 86400 seconds
    final int hours = ((time % 86400) / 3600).floor();
    final int minutes = ((time % 3600) / 60).floor();
    final int seconds = (time % 60).floor();

    return [
      days.toString().padLeft(2, "0"),
      hours.toString().padLeft(2, "0"),
      minutes.toString().padLeft(2, "0"),
      seconds.toString().padLeft(2, "0"),
    ];
  }

  Widget _buildTimeLeftContainer(BuildContext context) {
    return BlocBuilder<CommunityMissionBloc, CommunityMissionState>(
      builder: (context, state) {
        CommunityMission? communityMission = state.mission;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.only(top: 24, left: 16, bottom: 0, right: 16),
          child: Column(
            children: [
              Text(
                "TIME LEFT",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black.withValues(alpha: 0.54),
                ),
              ),
              SizedBox(height: 12),

              // Timer
              Countdown(
                controller: _timerController,
                seconds: differenceInSeconds,
                build: (BuildContext context, double time) {
                  List<String> timeList = formattedTime2(time);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      timeBox(timeList[0]),
                      timeColon(),
                      timeBox(timeList[1]),
                      timeColon(),
                      timeBox(timeList[2]),
                      timeColon(),
                      timeBox(timeList[3]),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),

              // Progress bar
              SizedBox(
                width: 260.w,
                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    LinearProgressIndicator(
                      minHeight: 20,
                      value: (communityMission?.usersJoined ?? 0) / 5000,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(Color(0xFFDEC4FF)),
                    ),
                    Positioned(
                      left: 50,
                      right: 50,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${communityMission?.usersJoined ?? 0} / $userGoal",
                              style: GoogleFonts.baloo2(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: " users joined",
                              style: GoogleFonts.baloo2(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Join button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
                child:
                    (state.hasJoined == MissionStatus.pending ||
                        ((communityMission?.usersJoined ?? 0) >= userGoal))
                    ? SizedBox(
                        height: 60,
                        child: FlowvaButton.inactiveButton(
                          name: "Join this mission",
                          fontSize: 16,
                          /*apply: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            // important for blur
                            builder: (_) => MissionInstructions(),
                          ),*/
                        ),
                      )
                    : state.hasJoined == MissionStatus.completed
                    ? Image.asset("assets/images/mark.png")
                    : FlowvaButton.blueButton(
                        name: "Join this mission",
                        fontSize: 16,
                        apply: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.transparent,
                          builder: (context) => ReclaimMissionPopup(),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget timeBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: GoogleFonts.baloo2(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.black.withValues(alpha: 0.44),
        ),
      ),
    );
  }

  Widget timeColon() {
    return Text(
      ":",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget strokeConnector() {
    return Column(
      children: [
        // Top circle
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        // Line
        Container(width: 3, height: 30, color: Color(0xFF767676)),
        // Bottom circle
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ],
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
