import 'package:flowva/features/common/flowva_app_bar.dart';
import 'package:flowva/features/mission/presentation/page/tabs/adventures_tab.dart';
import 'package:flowva/features/mission/presentation/page/tabs/overview_tab.dart';
import 'package:flowva/features/mission/presentation/page/tabs/skill_up_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../../onbaording/data/bloc/user_cubit.dart';
import '../bloc/community_mission_bloc.dart';
import '../bloc/featured_mission_bloc.dart';
import '../bloc/skill_up_bloc.dart';
import '../bloc/social_mission_bloc.dart';
import '../bloc/sponsored_mission_bloc.dart';

class MissionPage extends StatefulWidget {
  MissionPage({super.key, this.index});
  final int? index;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  var tab = ["Overview", "Adventures", "Skill Up" /*"Fun time"*/];
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int selectedIndex = 0;

  late CommunityMissionBloc communityMissionBloc;
  late SocialMissionBloc socialMissionBloc;
  late FeaturedMissionBloc featuredMissionBloc;
  late SponsoredMissionBloc sponsoredMissionBloc;
  late SkillUpBloc skillUpMissionBloc;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        selectedIndex = widget.index!;
        _pageController.jumpToPage(widget.index!);
      }
      final userCubit = UserCubit();
      userCubit.updateUserProfile();

      context.read<ProfileBloc>().add(GetProfileEvent());
      communityMissionBloc = BlocProvider.of<CommunityMissionBloc>(context);
      socialMissionBloc = BlocProvider.of<SocialMissionBloc>(context);
      featuredMissionBloc = BlocProvider.of<FeaturedMissionBloc>(context);
      sponsoredMissionBloc = BlocProvider.of<SponsoredMissionBloc>(context);
      skillUpMissionBloc = BlocProvider.of<SkillUpBloc>(context);

      communityMissionBloc.add(LoadCommunityMission());
      socialMissionBloc.add(LoadSocialMission());
      featuredMissionBloc.add(LoadFeaturedMission());
      sponsoredMissionBloc.add(LoadSponsoredMission());
      skillUpMissionBloc.add(LoadSkillUpMission());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),

          // 🔥 Gradient + soft blobs background
          // Container(child: Image.asset("assets/images/stacks.png")),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h + MediaQuery.of(context).padding.top),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FlowvaAppBar(title: "Missions"),
                ),
                const SizedBox(height: 12),
                // Tabs
                Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: tab.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected2 = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          _pageController.jumpToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected2 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(120),
                            border: isSelected2
                                ? Border.all(
                                    width: 0.2,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              tab[index],
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected2
                                    ? Colors.black
                                    : Colors.black.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      communityMissionBloc.add(LoadCommunityMission());
                      socialMissionBloc.add(LoadSocialMission());
                      featuredMissionBloc.add(LoadFeaturedMission());
                      sponsoredMissionBloc.add(LoadSponsoredMission());
                      skillUpMissionBloc.add(LoadSkillUpMission());
                    },
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: EarnOverviewScreen(),
                      ),
                      AdventuresTab(),
                      SkillUpPage(),
                      // TriviaPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
