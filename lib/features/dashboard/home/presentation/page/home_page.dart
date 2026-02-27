import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/app/view/widgets/gradient_progress.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/utils/helpers.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/profile/data/model/user_profile.dart';
import 'package:bravoo/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:bravoo/features/dashboard/profile/presentation/pages/profile_page.dart';
import 'package:bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../main.dart';
import '../../../mission/presentation/widget/mission_list_title.dart';
import '../../../nav_bar.dart';
import '../bloc/home_cubit.dart';
import '../bloc/notification_bloc.dart';
import '../widget/referral_widget.dart';
import '../widget/tool_card.dart';
import '../widget/top_leader_board.dart';
import 'notifications.dart';

class FlowvaHomePage extends StatefulWidget {
  const FlowvaHomePage({super.key});

  @override
  State<FlowvaHomePage> createState() => _FlowvaHomePageState();
}

class _FlowvaHomePageState extends State<FlowvaHomePage>
    with UIToolMixin, RouteAware {
  final sessionManager = SessionManager();
  UserProfile userProfile = UserProfile.empty();
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
    _logHomeActivity();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes using the global routeObserver
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route); // ← use global variable directly
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // ← use global variable directly
    super.dispose();
  }

  void didPopNext() {
    // Called when returning to this page from another page
    _logHomeActivity();
  }

  void _logHomeActivity() {
    profileBloc.add(LogUserHomeActivityEvent());
  }

  Future<void> _onRefresh() async {
    // Refresh profile
    profileBloc.add(GetProfileEvent());

    // Refresh home data
    context.read<HomeCubit>().fetchCampaigns();
    context.read<HomeCubit>().fetchSpotlight();
    context.read<HomeCubit>().fetchSpotlights();
    context.read<HomeCubit>().fetchQuote();
    context.read<HomeCubit>().fetchLeaderboard();
    context.read<HomeCubit>().getUserReferrals();
    context.read<HomeCubit>().fetchHomeMessage();
    context.read<HomeCubit>().fetchExtraHomeCard();

    // Refresh notifications
    context.read<NotificationBloc>().add(LoadNotifications());

    // Wait a bit for the data to load
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              userProfile = state.profile;
            });
          });
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_page_b.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    // Greeting Row
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Hey ${userProfile.name.trim()},",
                              style: TextStyles.titleSemiBold20(context),
                            ),
                          ),
                          Row(
                            spacing: 14.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BlocBuilder<NotificationBloc, NotificationState>(
                                builder: (context, state) {
                                  final noti = state.notification;
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => NotificationsPage(),
                                      ),
                                    ),
                                    child: Container(
                                      width: 28.w,
                                      height: 28.h,
                                      child: Stack(
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedNotification01,
                                            size: 28.sp,
                                          ),
                                          if (noti.any((e) => e.read == false))
                                            Positioned(
                                              top: 0,
                                              right: 2.w,
                                              child: Container(
                                                width: 12.w,
                                                height: 12.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.error,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(),
                                    ),
                                  );
                                },
                                child: CachedImageRadius(
                                  imageUrl: userProfile.profilePic,
                                  size: 30,
                                  circle: true,
                                  fit: BoxFit.cover,
                                  color: AppColors.grey200,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppColors.primary,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 0),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 18.h),
                              if (SessionManager().firstTimeUserVal ==
                                  "YES") ...[
                                MessageContainer(
                                  onTap: () {
                                    setState(() {
                                      SessionManager().firstTimeUserVal = "NO";
                                    });
                                  },
                                ),
                                SizedBox(height: 16.h),
                              ],
                              ToolCardCarousel(),
                              SizedBox(height: 20.h),
                              MissionAwaitWidget(),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Growth Missions",
                                            style: GoogleFonts.baloo2(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            BottomNavBar(
                                                              index: 1,
                                                              missionIndex: 1,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 20,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 9,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF6E4E6),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFE9E9E9,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            28,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "See more",
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                              0xFF020617,
                                                            ),
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      MissionCard(isFull: false),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  final leaderboard =
                                      state.leaderboard.leaderboard;
                                  if (leaderboard.isNotEmpty &&
                                      leaderboard.length > 2)
                                    return TopLeaderboard(
                                      leaderboard: leaderboard,
                                    );
                                  else
                                    return SizedBox.shrink();
                                },
                              ),

                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: ReferralWidget(),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({super.key, required this.onTap});

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final homeMessage = state.homeMessage;
        if (homeMessage.title.isEmpty) {
          return SizedBox();
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexToColor(homeMessage.gradientColor.start),
                hexToColor(homeMessage.gradientColor.end),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            spacing: 4.h,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: homeMessage.title,
                        style: TextStyles.normalBold14(
                          context,
                        ).copyWith(color: hexToColor(homeMessage.textColor)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      AssetsSvgIcons.close,
                      width: 14.r,
                      height: 14.r,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        hexToColor(homeMessage.textColor),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              MarkdownBody(
                data: homeMessage.message,
                onTapLink: (text, href, title) async {
                  if (href != null) {
                    final uri = Uri.parse(href);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                styleSheet: MarkdownStyleSheet(
                  a: TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  p: TextStyles.smallMedium12(context).copyWith(
                    color: hexToColor(
                      homeMessage.textColor,
                    ).withValues(alpha: .65),
                  ),
                  strong: TextStyles.smallBold12(context).copyWith(
                    color: hexToColor(
                      homeMessage.textColor,
                    ).withValues(alpha: .65),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MissionAwaitWidget extends StatelessWidget {
  const MissionAwaitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            // padding: const EdgeInsets.all(2),
            height: 82.h,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Left Section
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(color: AppColors.primary),
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title + Arrow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "More missions await",
                                  style: TextStyles.smallMedium12(
                                    context,
                                  ).copyWith(color: AppColors.grey200),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${formatAmount(profile.totalPoints)}",
                                    style: TextStyles.bodySemiBold16(
                                      context,
                                    ).copyWith(color: AppColors.white),
                                  ),
                                  TextSpan(
                                    text:
                                        " / ${formatAmount(profile.basePoints)}",
                                  ),
                                ],
                                style: TextStyles.smallMedium12(
                                  context,
                                ).copyWith(color: AppColors.grey300),
                              ),
                            ),
                          ],
                        ),
                        // Progress Bar
                        GradientProgress(
                          height: 8,
                          progress:
                              (profile.totalPoints) / (profile.basePoints),
                        ),
                        // Bottom text
                        if ((profile.totalPoints) < (profile.basePoints))
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text:
                                  "Just ${(profile.basePoints) - (profile.totalPoints)} "
                                  " more till your next reward! ✨",
                              style: TextStyles.cardSemibold10(
                                context,
                              ).copyWith(color: AppColors.grey200),
                            ),
                          )
                        else
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text:
                                  "Congratulations on getting to ${formatAmount(profile.totalPoints)} coins!!",
                              style: TextStyles.cardSemibold10(
                                context,
                              ).copyWith(color: AppColors.grey200),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Right Section - Circular Rewards
                Container(
                  color: AppColors.white50,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 12.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/one_50.png", height: 30),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Redeem",
                          style: TextStyles.normalMedium14(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
