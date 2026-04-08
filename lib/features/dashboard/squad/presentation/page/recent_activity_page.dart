import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/model/response/recent_activity_model.dart';
import '../bloc/activity_bloc.dart' hide ActivityType;
import '../widget/recent_activity_tile.dart';

class RecentActivityPage extends StatefulWidget {
  const RecentActivityPage({super.key});

  @override
  State<RecentActivityPage> createState() => _RecentActivityPageState();
}

class _RecentActivityPageState extends State<RecentActivityPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RecentActivityBloc>();
    if (bloc.state.activities.isEmpty) {
      bloc.add(FetchActivityEvent());
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Fire FetchMoreActivityEvent when within 200px of the bottom
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      context.read<RecentActivityBloc>().add(FetchMoreActivityEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.black05,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft02,
                  color: Colors.black,
                  strokeWidth: 1.5,
                ),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Recent Activities",
                  style: TextStyles.titleSemiBold20(context),
                ),
              ),
            ),
            Opacity(
              opacity: 0,
              child: CircleAvatar(
                backgroundColor: AppColors.black05,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft02,
                  color: Colors.black,
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              Expanded(
                child: BlocBuilder<RecentActivityBloc, RecentActivityState>(
                  builder: (context, state) {
                    List<RecentActivity> recentActivity = state.activities;
                    final isLoadingMore = state is ActivityLoadingMoreState;

                    // ── Full screen loader on first fetch ──────────────────────
                    if (state is ActivityLoadingState &&
                        recentActivity.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // ── Error with empty list ──────────────────────────────────
                    else if (state is ActivityErrorState &&
                        recentActivity.isEmpty) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message),
                            TextButton(
                              onPressed: () => context
                                  .read<RecentActivityBloc>()
                                  .add(FetchActivityEvent()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (recentActivity.isEmpty) {
                      return Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'No Recent Activity',
                            style: TextStyles.normalRegular14(context),
                          ),
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<RecentActivityBloc>().add(
                            FetchActivityEvent(),
                          );
                          // Wait until the bloc emits a non-loading state
                          await context
                              .read<RecentActivityBloc>()
                              .stream
                              .firstWhere(
                                (s) =>
                                    s is ActivityLoadedState ||
                                    s is ActivityErrorState,
                              );
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: recentActivity.length + 1,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          itemBuilder: (context, index) {
                            // Last item = load-more indicator
                            if (index == recentActivity.length) {
                              if (isLoadingMore) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (!state.hasMore) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "You're all caught up 🎉",
                                        style: TextStyles.normalRegular14(
                                          context,
                                          opacity: .5,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // More pages available but not loading yet
                              return const SizedBox.shrink();
                            }
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
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
