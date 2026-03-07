import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/mission/data/model/new_social_mission_model.dart';
import 'package:bravoo/features/dashboard/mission/presentation/bloc/new_social_mission_bloc.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../data/model/mission_status_enum.dart';
import '../../widget/follow_us_card.dart';
import '../../widget/new_social_card.dart';

class SocialTab extends StatefulWidget {
  const SocialTab({super.key});

  @override
  State<SocialTab> createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> with UIToolMixin {
  List<NewSocialMission> missions = [];
  List<MissionStatus> socialMissionStatus = [];

  @override
  void initState() {
    super.initState();
    final socialBloc = context.read<NewSocialMissionBloc>();
    missions = socialBloc.state.missions;
    socialMissionStatus = socialBloc.state.hasJoined;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSocialMissionBloc, NewSocialMissionState>(
      builder: (context, state) {
        missions = state.missions;
        socialMissionStatus = state.hasJoined;

        bool loading =
            state is NewSocialMissionLoading &&
            state.type == NewSocialMissionType.fetchMission;

        return Container(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              children: [
                FollowUsCard(),
                if (missions.isEmpty && loading) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return FadeShimmer(
                        width: double.infinity,
                        height: 226.h,
                        radius: 32.r,
                        baseColor: AppColors.darkPrimary05,
                        highlightColor: AppColors.grey300.withValues(
                          alpha: .25,
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(height: 24.h),
                  ),
                ] else if (missions.isNotEmpty) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final socialMission = missions[index];
                      final missionStatus = socialMissionStatus[index];

                      return NewSocialCard(
                        socialMission: socialMission,
                        missionStatus: missionStatus,
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(height: 24.h),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
