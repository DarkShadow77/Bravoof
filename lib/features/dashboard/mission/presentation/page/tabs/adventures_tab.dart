import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/earn/data/models/mission_res.dart';
import 'package:bravoo/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:bravoo/features/dashboard/mission/presentation/bloc/growth_mission_bloc.dart';
import 'package:bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
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

  List<Mission> missions = [];

  @override
  void initState() {
    super.initState();
    missions = context.read<GrowthMissionBloc>().state.missions;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF8F4FF),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            CommunityMissionCard(),
            SizedBox(height: 20.h),
            ReferCampaign(),
            SizedBox(height: 20.h),
            _buildGrowthMission(),
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
    );
  }

  Widget _buildGrowthMission() {
    int sum = missions.where((e) => e.completed == true).length;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white60,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Your Growth Begins With a Mission',
              style: TextStyles.titleBold20(context).copyWith(
                color: AppColors.primary,
                fontFamily: AppFonts.baloo2,
                height: 1.sp,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          BlocBuilder<GrowthMissionBloc, GrowthMissionState>(
            builder: (context, state) {
              missions = state.missions;
              return SizedBox(
                width: 59,
                height: 59,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: Container(
                        height: 100,
                        width: 100,
                        child: Transform.rotate(
                          angle: -0.14 / 2,
                          child: CircularProgressIndicator(
                            value: sum / missions.length,
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
              );
            },
          ),
          SizedBox(height: 14.h),
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
    );
  }
}
