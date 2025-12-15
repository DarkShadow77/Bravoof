import 'dart:async';

import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/perk_mission.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/social_trivia_response.dart';
import 'package:flowva/features/mission/presentation/widget/mission_intructions.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/jackpot_page.dart';
import 'claim_widget.dart';
import 'follow_us_card.dart';

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
  Duration timeLeft = Duration(days: 00, hours: 24, minutes: 13, seconds: 13);
  late Timer _timer;
  late HomeCubit homeCubit;
  int usersJoined = 2500;
  int userGoal = 5000;
  bool init = true;
  bool isInstagramCompleted = true;
  bool isPerkCompleted = false;
  bool isCommunityCompleted = false;
  List<Campaign> campaign = [];
  List<Mission> missions = [];
  List<SocialTrivia> socialTrivia = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted && timeLeft.inSeconds > 0) {
        setState(() {
          timeLeft = timeLeft - Duration(seconds: 1);
        });
      }
    });
  }

  String formatTimeUnit(int unit) => unit.toString().padLeft(2, '0');

  // Community mission counts
  int joinedUsers = 4213;
  final int targetUsers = 5000;
  int sum = 0;

  // End time for community mission (example: 2 days from now)
  late DateTime missionEndTime;

  // Enter to win next-round countdown (e.g. next round in 5h23m from now)
  late DateTime nextRoundTime;
  late MissionCubit missionCubit;
  Timer? _nextRoundTimer;
  Duration nextRoundRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
    missionCubit = MissionCubit();
    homeCubit = HomeCubit();

    homeCubit.fetchCampaigns();
    missionCubit.fetchMission();
    missionCubit.fetchSkillUpChallenge();

    // set mission end to 2 days in future for demo
    missionEndTime = DateTime.now().add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _timer.cancel();
    _nextRoundTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = usersJoined / userGoal;
    final days = timeLeft.inDays;
    final hours = timeLeft.inHours.remainder(24);
    final minutes = timeLeft.inMinutes.remainder(60);
    final seconds = timeLeft.inSeconds.remainder(60);
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
              }
              if (state is MissionLoaded) {
                setState(() {
                  init = false;
                });
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
                      e.completed!) {
                    isCommunityCompleted = e.completed!;
                  }
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
            bloc: homeCubit,
            listener: (context, state) {
              print(state);
              if (state is CampaignLoaded) {
                campaign = state.campaignResponse.campaign!;
              }
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
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                children: [
                  // COMMUNITY MISSIONS CARD
                  Stack(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: Color(0xFF9013FE).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                  style: GoogleFonts.baloo2(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                    color: Color(0xFFA259FF),
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
                                  "Explore the AI calendar that plans your day",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Card bottom section
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: EdgeInsets.only(
                              top: 24,
                              left: 16,
                              bottom: 0,
                              right: 16,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "TIME LEFT",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.54),
                                  ),
                                ),
                                SizedBox(height: 12),

                                // Timer
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    timeBox(formatTimeUnit(timeLeft.inDays)),
                                    timeColon(),
                                    timeBox(formatTimeUnit(timeLeft.inHours)),
                                    timeColon(),
                                    timeBox(
                                      formatTimeUnit(timeLeft.inMinutes % 60),
                                    ),
                                    timeColon(),
                                    timeBox(
                                      formatTimeUnit(timeLeft.inSeconds % 60),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Progress bar
                                SizedBox(
                                  width: 260,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.85 *
                                            progress,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFA259FF),
                                              Color(0xFFDEC4FF),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(left: 8),
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
                                                    "$usersJoined / $userGoal",
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
                                  child: isCommunityCompleted
                                      ? SizedBox(
                                          height: 60,
                                          child: FlowvaButton.inactiveButton(
                                            name: "Join this mission",
                                            fontSize: 16,
                                            apply: () => showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: Colors.transparent,
                                              backgroundColor:
                                                  Colors.transparent,
                                              // important for blur
                                              builder: (_) =>
                                                  MissionIntructions(),
                                            ),
                                          ),
                                        )
                                      : FlowvaButton.blueButton(
                                          name: "Join this mission",
                                          fontSize: 16,
                                          apply: () => showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: Colors.transparent,
                                            builder: (context) =>
                                                ReclaimMissionPopup(),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
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
                        right: 100, // Horizontal position of right stroke
                        child: strokeConnector(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  campaign.isNotEmpty
                      ? ReferCampaign(campaign: campaign)
                      : Container(),
                  const SizedBox(height: 20),

                  // Growth Missions header
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
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
                                  color: Colors.pink.shade50.withOpacity(0.02),
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
                                      valueColor: const AlwaysStoppedAnimation(
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
                                  color: Colors.white.withOpacity(0.5),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF8A3BFF),
                                                  ),
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
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.04,
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
                                                          alignment:
                                                              Alignment.center,
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
                                                                    color: const Color(
                                                                      0xFF7367F0,
                                                                    ).withOpacity(0.5),
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
                                                                      color: const Color(
                                                                        0xFFFF8A80,
                                                                      ).withOpacity(0.5),
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
                                            //     color: Colors.black.withOpacity(0.34),
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
                                    mission.subject!.toLowerCase() == "watch") {
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
                                if (mission.subject!.toLowerCase() == "invite")
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
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Image.asset(
                    "assets/images/fest.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  FollowUsCard(socialTrivia: socialTrivia),

                  const SizedBox(height: 20),
                  Container(
                    height: 400,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Perks and Beyond',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/one_50.png",
                                  height: 12,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '500',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Free Comet AI for Students",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        Image.asset(
                          "assets/images/pelplex.png",
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        isPerkCompleted
                            ? Container(
                                height: 50,

                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Start mission",
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor: Colors.transparent,
                                      builder: (context) =>
                                          PerkMission(apply: (val) {}),
                                    ).then((v) {
                                      missionCubit.fetchSkillUpChallenge();
                                    }),
                                child: Container(
                                  height: 50,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Start mission",
                                      style: GoogleFonts.manrope(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  DiscoverPerks(),

                  SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    );
  }

  Widget _timerBox(String text) {
    return Container(
      // margin: const EdgeInsets.only(left: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }

  Widget timeBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: GoogleFonts.baloo2(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.black.withOpacity(0.44),
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

class DiscoverPerks extends StatefulWidget {
  DiscoverPerks({super.key});

  @override
  State<DiscoverPerks> createState() => _DiscoverPerksState();
}

class _DiscoverPerksState extends State<DiscoverPerks> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            controller: _pageController,
            onPageChanged: (int val) {
              setState(() {
                currentPage = val;
              });
            },

            children: [
              Container(
                height: 190,

                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,

                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discover Perks Made for You",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Color(0xFFA5A5A5),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Claim 50% OFF",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                // SizedBox(height: 10),
                                Text(
                                  "Enjoy  Pro Access to Jotform",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Valid 1 year",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF9013FE),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FlowvaButton.subButton(name: "Redeem offer"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 170,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              height: 170,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6100).withOpacity(0.48),
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Image.asset("assets/images/jotform.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.35),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 190,

                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,

                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discover Perks Made for You",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Color(0xFFA5A5A5),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Claim 20% OFF",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                // SizedBox(height: 10),
                                Text(
                                  "Enjoy  Pro Access to Jotform",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Valid 3 year",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF9013FE),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FlowvaButton.subButton(name: "Redeem offer"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 170,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              height: 170,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF5263F3).withOpacity(0.48),
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Image.asset(
                                "assets/images/reclaim_trans.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.35),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 190,

                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,

                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discover Perks Made for You",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Color(0xFFA5A5A5),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Claim 10% OFF",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                // SizedBox(height: 10),
                                Text(
                                  "Enjoy  Pro Access to Jotform",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Valid forever",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF9013FE),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FlowvaButton.subButton(name: "Redeem offer"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 170,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              height: 170,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF000A3A).withOpacity(0.48),
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Image.asset(
                                "assets/images/perk_stack.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.35),
                      child: Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            3, // number of indicators
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 16,
                height: 4,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? Color(0xFF400387)
                      : Color(0xFF400387).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _progressTextFromValue(double progress) {
  // simple mapping for demo: 0 -> 0/1, 1/3 -> 1/3, etc.
  if (progress == 0.0) return '0/1';
  if ((progress - 1 / 3).abs() < 0.01) return '1/3';
  // fallback
  return '${(progress * 1).round()}/${1}';
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
            color: Colors.black.withOpacity(0.05),
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
                          ? Colors.black.withOpacity(0.24)
                          : Colors.black.withOpacity(0.50),
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
                //                 color: Colors.white.withOpacity(0.42),
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
                  : Color(0xFF9013FE).withOpacity(0.08),
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
                        color: Colors.black.withOpacity(0.34),
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
