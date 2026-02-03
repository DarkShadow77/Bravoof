import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:Bravoo/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:Bravoo/features/dashboard/redeem/presentation/page/tabs/history_tab.dart';
import 'package:Bravoo/features/dashboard/redeem/presentation/page/tabs/redeem_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/flowva_app_bar.dart';
import '../../../mission/presentation/bloc/community_mission_bloc.dart';
import '../../../mission/presentation/bloc/featured_mission_bloc.dart';
import '../../../mission/presentation/bloc/growth_mission_bloc.dart';
import '../../../mission/presentation/bloc/skill_up_bloc.dart';
import '../../../mission/presentation/bloc/social_mission_bloc.dart';
import '../../../mission/presentation/bloc/sponsored_mission_bloc.dart';
import '../../../mission/presentation/bloc/streak_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/redeem_bloc.dart';

class RedeemScreen extends StatefulWidget {
  RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  List<CampaignResponseModel> campaign = [];
  var tab = ["Redeem", "History"];
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).fetchCampaigns();
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
    context.read<RedeemBloc>().add(LoadRedeemHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h + MediaQuery.of(context).padding.top),
                FlowvaAppBar(title: "Redeem"),
                SizedBox(height: 12.h),
                // Tabs
                Container(
                  height: 45,

                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    itemCount: tab.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      final isSelected2 = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          _pageController.jumpToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
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
                      _fetchDetails();
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    children: [RedeemTab(), HistoryTab()],
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
