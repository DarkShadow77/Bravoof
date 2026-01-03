import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/features/dashboard/home/presentation/page/home_page.dart';
import 'package:flowva/features/dashboard/redeem/presentation/page/redeem_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../session/session_manager.dart';
import '../onboarding2/widget/reward.dart';
import 'home/presentation/widget/show_welcome_message.dart';
import 'mission/presentation/bloc/community_mission_bloc.dart';
import 'mission/presentation/bloc/featured_mission_bloc.dart';
import 'mission/presentation/bloc/growth_mission_bloc.dart';
import 'mission/presentation/bloc/skill_up_bloc.dart';
import 'mission/presentation/bloc/social_mission_bloc.dart';
import 'mission/presentation/bloc/sponsored_mission_bloc.dart';
import 'mission/presentation/bloc/streak_bloc.dart';
import 'mission/presentation/page/mission_page.dart';
import 'profile/presentation/bloc/profile_bloc.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  final int? missionIndex;
  // int i;
  BottomNavBar({this.index = 0, super.key, this.missionIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  int currentI = 0;
  @override
  void initState() {
    // currentI=widget.i;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentIndex = widget.index;
      SessionManager().firstWelcomeUserVal == "YES"
          ? Future.delayed(
              Duration(milliseconds: 500),
              () => showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierLabel: "",
                barrierColor: Colors.transparent,
                pageBuilder: (_, _, _) => ShowWelcomeMessage(),
              ),
            )
          : null;

      SessionManager().isNewUserVal == "YES"
          ? showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.transparent,
              builder: (_) => const RewardWidget(),
            )
          : null;

      SessionManager().isNewUserVal = "NO";
    });
    _fetchDetails();
  }

  _fetchDetails() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<CommunityMissionBloc>().add(LoadCommunityMission());
    context.read<SocialMissionBloc>().add(LoadSocialMission());
    context.read<FeaturedMissionBloc>().add(LoadFeaturedMission());
    context.read<SponsoredMissionBloc>().add(LoadSponsoredMission());
    context.read<GrowthMissionBloc>().add(LoadGrowthMission());
    context.read<SkillUpBloc>().add(LoadSkillUpMission());
    context.read<StreakBloc>().add(LoadStreaksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //,DiscoverScreen(),LibraryScreen(),
        body: IndexedStack(
          index: currentIndex,
          children: [
            FlowvaHomePage(),
            MissionPage(index: widget.missionIndex),
            RedeemScreen(),
          ],
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFA5A5A5).withOpacity(0.3), // Outline color
                width: 0.5, // Thickness
              ),
            ),
          ),

          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            currentIndex: currentIndex,
            selectedLabelStyle: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF2B2B2B),
            ),
            unselectedLabelStyle: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA5A5A5),
            ),
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });

              _fetchDetails();
            },
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0
                    ? SvgPicture.asset(
                        AssetsNavbar.homeActive,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.asset(
                        AssetsNavbar.home,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1
                    ? SvgPicture.asset(
                        AssetsNavbar.missionActive,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.asset(
                        AssetsNavbar.mission,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                label: "Mission",
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? SvgPicture.asset(
                        AssetsNavbar.redeemActive,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.asset(
                        AssetsNavbar.redeem,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                label: "Redeem",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit this app'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(true);
                }, // <-- SEE HERE
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
