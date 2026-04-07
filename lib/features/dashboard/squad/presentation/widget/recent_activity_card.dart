import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../data/model/response/recent_activity_model.dart';
import '../bloc/activity_bloc.dart' hide ActivityType;
import 'recent_activity_tile.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentActivityBloc, RecentActivityState>(
      builder: (context, state) {
        List<RecentActivity> recentActivity = state.activities.take(5).toList();
        // ── Full screen loader on first fetch ──────────────────────
        if (state is ActivityLoadingState && recentActivity.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // ── Error with empty list ──────────────────────────────────
        else if (state is ActivityErrorState && recentActivity.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                TextButton(
                  onPressed: () => context.read<RecentActivityBloc>().add(
                    FetchActivityEvent(),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (recentActivity.isEmpty) {
          return SizedBox(
            height: 150.h,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'No Recent Activity',
                  style: TextStyles.normalRegular14(context),
                ),
              ),
            ),
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: recentActivity.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              RecentActivity activity = recentActivity[index];
              return RecentActivityTile(
                activity: activity,
                onReact: (reaction) {
                  context.read<RecentActivityBloc>().add(
                    ReactToActivityEvent(
                      activityId: activity.id,
                      emoji: reaction,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
          );
        }
      },
    );
  }
}
