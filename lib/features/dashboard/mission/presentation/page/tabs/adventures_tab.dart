import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../data/bloc/mission_cubit.dart';
import '../../bloc/community_mission_bloc.dart';
import '../../bloc/featured_mission_bloc.dart';
import '../../bloc/social_mission_bloc.dart';
import '../../bloc/sponsored_mission_bloc.dart';
import '../../widget/community_mission_card.dart';
import '../../widget/discover_perks.dart';
import '../../widget/featured_card.dart';
import '../../widget/follow_us_card.dart';
import '../../widget/mission_list_title.dart';
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

  /*missions.forEach((e) {
  if (e.completed!) {
  setState(() {
  sum += 1;
  });
  }
  });
  print(sum);*/

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF8F4FF),
      child: MultiBlocListener(
        listeners: [
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
                          SizedBox(height: 14),
                          Text(
                            "Unlock Spins by completing Missions. Keep going !",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF767676),
                            ),
                          ),
                          // Circular progress + text
                          const SizedBox(height: 24),
                          MissionCard(),
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
