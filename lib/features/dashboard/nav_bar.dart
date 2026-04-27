import 'dart:io';

import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/app_colors.dart';
import 'package:bravoo/features/dashboard/home/presentation/page/home_page.dart';
import 'package:bravoo/features/dashboard/redeem/presentation/page/redeem_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../session/session_manager.dart';
import '../onbaording/widget/reward.dart';
import 'home/presentation/bloc/home_cubit.dart';
import 'home/presentation/bloc/notification_bloc.dart';
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
import 'redeem/presentation/bloc/redeem_bloc.dart';
import 'squad/presentation/bloc/activity_bloc.dart';
import 'squad/presentation/bloc/brand_bloc.dart';
import 'squad/presentation/bloc/squad_bloc.dart';
import 'squad/presentation/page/squad_page.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    this.index = 0,
    super.key,
    this.missionIndex,
    this.redeemIndex,
  });

  final int index;
  final int? missionIndex;
  final int? redeemIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    currentIndex = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Show welcome/reward dialogs
      if (SessionManager().firstWelcomeUserVal == "YES") {
        Future.delayed(Duration(milliseconds: 500), () {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: "",
            barrierColor: Colors.transparent,
            pageBuilder: (_, _, _) => ShowWelcomeMessage(),
          );
        });
      }

      if (SessionManager().isNewUserVal == "YES") {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (_) => const RewardWidget(),
        );
      }

      SessionManager().isNewUserVal = "NO";

      // Use Supabase session as source of truth
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Force refresh the session before fetching anything
        try {
          await Supabase.instance.client.auth.refreshSession();
        } catch (_) {}
      }

      final profileUserId = context.read<ProfileBloc>().state.profile.userId;
      if (session != null && profileUserId.isNotEmpty) {
        _fetchDetails();
      }
      ;
    });
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
    context.read<RedeemBloc>().add(LoadRedeemHistory());
    context.read<NotificationBloc>().add(LoadNotifications());
    context.read<SquadBloc>().add(FetchSquadsEvent());
    context.read<BrandBloc>().add(FetchBrandsEvent());
    context.read<HomeCubit>().checkIncompleteSquadMissions();
    context.read<HomeCubit>().checkIncompleteBrandMissions();
    context.read<RecentActivityBloc>().add(FetchActivityEvent());

    // Refresh home data
    context.read<HomeCubit>().fetchCampaigns();

    if (currentIndex == 0) {
      context.read<HomeCubit>().fetchSpotlight();
      context.read<HomeCubit>().fetchSpotlights();
      context.read<HomeCubit>().fetchQuote();
      context.read<HomeCubit>().fetchLeaderboard();
      context.read<HomeCubit>().getUserReferrals();
      context.read<HomeCubit>().fetchHomeMessage();
      context.read<HomeCubit>().fetchExtraHomeCard();
    } else if (currentIndex == 1) {
      context.read<HomeCubit>().checkComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) => _onWillPop(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) =>
                previous.profile.userId.isEmpty &&
                current.profile.userId.isNotEmpty,
            listener: (context, state) {
              _fetchDetails();
            },
          ),
          BlocListener<SquadBloc, SquadState>(
            listenWhen: (prev, curr) => prev.squads != curr.squads,
            listener: (context, state) {
              context.read<HomeCubit>().checkIncompleteSquadMissions();
            },
          ),
          BlocListener<BrandBloc, BrandState>(
            listenWhen: (prev, curr) => prev.brands != curr.brands,
            listener: (context, state) {
              context.read<HomeCubit>().checkIncompleteBrandMissions();
            },
          ),
        ],
        child: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              FlowvaHomePage(),
              MissionPage(index: widget.missionIndex),
              SquadPage(),
              RedeemScreen(index: widget.missionIndex),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey100, width: 1.r),
              ),
            ),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final hasIncomplete = state.hasIncompleteMissions;
                return BottomNavigationBar(
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
                      icon: SizedBox(
                        width: 24.w,
                        child: Stack(
                          children: [
                            currentIndex == 1
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
                            if (hasIncomplete)
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 12.r,
                                  height: 12.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      label: "Mission",
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 24.w,
                        child: Stack(
                          children: [
                            currentIndex == 2
                                ? SvgPicture.asset(
                                    AssetsNavbar.squadActive,
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.contain,
                                  )
                                : SvgPicture.asset(
                                    AssetsNavbar.squad,
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.contain,
                                  ),
                            if (state.hasIncompleteSquadMissions ||
                                state.hasIncompleteBrandMissions)
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 12.r,
                                  height: 12.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      label: "Squad",
                    ),
                    BottomNavigationBarItem(
                      icon: currentIndex == 3
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _onWillPop() async {
    if (currentIndex == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit this app'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              //<-- SEE HERE
              child: new Text('No'),
            ),
            TextButton(onPressed: () => exit(0), child: new Text('Yes')),
          ],
        ),
      );
    } else {
      setState(() {
        currentIndex = 0;
      });
    }
  }
}
