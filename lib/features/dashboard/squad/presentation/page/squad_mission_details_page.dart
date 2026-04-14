import 'package:bravoo/app/view/widgets/gradient_progress.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_mission_model.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:bravoo/features/dashboard/squad/presentation/bloc/activity_bloc.dart';
import 'package:bravoo/features/dashboard/squad/presentation/widget/squad_mission_instruction_dialog.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../common/app_enum.dart';
import '../../../earn/presentation/pages/invite_earn.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/squad_bloc.dart';
import '../bloc/squad_individual_bloc.dart';
import '../bloc/squad_mission_bloc.dart';
import '../widget/joined_squad_mission_dialog.dart';
import 'squad_mission_chat_page.dart';

class SquadMissionDetailsPage extends StatefulWidget {
  const SquadMissionDetailsPage({
    super.key,
    required this.squad,
    required this.squadMission,
  });

  final Squad squad;
  final SquadMission squadMission;

  @override
  State<SquadMissionDetailsPage> createState() =>
      _SquadMissionDetailsPageState();
}

class _SquadMissionDetailsPageState extends State<SquadMissionDetailsPage>
    with UIToolMixin {
  late Squad squad;
  late SquadMission squadMission;

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  static const double _collapseThreshold = 220;

  @override
  void initState() {
    squad = widget.squad;
    squadMission = widget.squadMission;
    super.initState();
    context.read<SquadIndividualBloc>().add(FetchSquadMissionsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > _collapseThreshold;
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  _loadingState(BuildContext context, SquadMissionLoadingState state) {
    if (state.type == SquadMissionType.joinMission &&
        state.missionId == squadMission.id) {
      outerLoadingDialog(text: "Joining Squad Mission");
    } else if (state.type == SquadMissionType.leaveMission &&
        state.missionId == squadMission.id) {
      outerLoadingDialog(text: "Leaving Squad Mission");
    }
  }

  _successState(BuildContext context, SquadMissionSuccessState state) {
    if (state.type == SquadMissionType.leaveMission &&
        state.missionId == squadMission.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<SquadIndividualBloc>().add(FetchSquadMissionsEvent());
      context.read<RecentActivityBloc>().add(FetchActivityEvent());
    }
  }

  _joinedState(BuildContext context, JoinedSquadMissionState state) {
    if (state.missionId == squadMission.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<SquadIndividualBloc>().add(FetchSquadMissionsEvent());
      context.read<RecentActivityBloc>().add(FetchActivityEvent());
      joinedSquadMissionDialog(
        squadMission: squadMission,
        joinedSquadMission: state.joinedSquadMission,
        onTap: () => squadMissionInstructionDialog(
          squadMission: squadMission,
          showChat: true,
          onChatPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<SquadMissionBloc>(),
                child: SquadMissionChatPage(
                  mission: squadMission,
                  chatRoomId: squadMission.chatRoomId!,
                  onMissionSubmitted: () {
                    context.read<SquadIndividualBloc>().add(
                      FetchSquadMissionsEvent(),
                    );
                    context.read<RecentActivityBloc>().add(
                      FetchActivityEvent(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  _failureState(BuildContext context, SquadMissionErrorState state) {
    if ((state.type == SquadMissionType.joinMission ||
            state.type == SquadMissionType.leaveMission) &&
        state.missionId == squadMission.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(state.message, context, status: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SquadMissionBloc, SquadMissionState>(
      listener: (context, state) {
        if (state is SquadMissionLoadingState) {
          _loadingState(context, state);
        }
        if (state is SquadMissionSuccessState) {
          _successState(context, state);
        }
        if (state is JoinedSquadMissionState) {
          _joinedState(context, state);
        }
        if (state is SquadMissionErrorState) {
          _failureState(context, state);
        }
      },
      child: BlocBuilder<SquadBloc, SquadState>(
        builder: (context, squadState) {
          squad = squadState.squads.firstWhere((e) => e.id == squad.id);
          return BlocBuilder<SquadIndividualBloc, SquadIndividualState>(
            builder: (context, squadIndividualState) {
              squadMission = squadIndividualState.missions.firstWhere(
                (e) => e.id == squadMission.id,
              );
              final double progress = squadMission.maxUsers == 0
                  ? 0.0
                  : squadMission.usersJoined / squadMission.maxUsers;
              final double safeProgress = progress.clamp(0.0, 1.0);

              return Scaffold(
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/earn_bg.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    CustomScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // App Bar with Image
                        SliverAppBar(
                          expandedHeight: 300.h,
                          pinned: true,
                          backgroundColor: Color(0xffFFE0E1),
                          automaticallyImplyLeading: false,
                          title: _CollapsedAppBar(
                            isCollapsed: _isCollapsed,
                            squadMission: squadMission,
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: _ExpandedAppBar(
                              squadMission: squadMission,
                              isCollapsed: _isCollapsed,
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            GradientProgress(
                              height: 6.h,
                              progress: safeProgress,
                              radius: 0,
                            ),
                          ]),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(height: 5.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text:
                                          "${squadMission.usersJoined}/${squadMission.maxUsers} ",
                                      children: [
                                        TextSpan(
                                          text: "Joined!",
                                          style: TextStyles.smallSemibold12(
                                            context,
                                            opacity: .65,
                                          ),
                                        ),
                                      ],
                                      style: TextStyles.normalSemibold14(
                                        context,
                                        opacity: .65,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      text: "${squadMission.timeLeft}",
                                      style: TextStyles.smallSemibold12(
                                        context,
                                        opacity: .65,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              _buildShareContainer(context),
                              SizedBox(height: 8.h),
                              if (squadMission.isJoined)
                                BlocBuilder<
                                  SquadMissionBloc,
                                  SquadMissionState
                                >(
                                  builder: (context, missionState) {
                                    final isLeaving =
                                        missionState
                                            is SquadMissionLoadingState &&
                                        missionState.type ==
                                            SquadMissionType.leaveMission;

                                    return IconTextButton(
                                      onPressed: () {
                                        context.read<SquadMissionBloc>().add(
                                          LeaveSquadMissionEvent(),
                                        );
                                      },
                                      height: 48.h,
                                      text: "Leave Mission",
                                      buttonState: isLeaving
                                          ? AppButtonState.loading
                                          : AppButtonState.idle,
                                      color: AppColors.error,
                                      textColor: AppColors.white,
                                    );
                                  },
                                ),
                              SizedBox(height: 20.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Overview",
                                  style: TextStyles.titleSemiBold20(context)
                                      .copyWith(
                                        height: 1.h,
                                        fontFamily: AppFonts.baloo2,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: squadMission.about.isEmpty
                                      ? "No Description"
                                      : squadMission.about,
                                  style: TextStyles.smallMedium12(
                                    context,
                                    opacity: .75,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 19.h,
                                  horizontal: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.white,
                                      hexToColor(squad.gradientColor.end),
                                      hexToColor(squad.gradientColor.start),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  spacing: 16.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      spacing: 7.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _buildSquadDetailContainer(
                                            context,
                                            title: "Squad",
                                            value:
                                                "${squad.name.capitalize} Squad",
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildSquadDetailContainer(
                                            context,
                                            title: "Who can play?",
                                            value: "Squad members",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 7.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _buildSquadDetailContainer(
                                            context,
                                            title: "Reward",
                                            valueWidget: Row(
                                              spacing: 4.w,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  AssetsPngImages.one50,
                                                  height: 20.r,
                                                  width: 20.r,
                                                ),
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "${formatAmount(squadMission.points)}",
                                                    style:
                                                        TextStyles.bodySemiBold16(
                                                          context,
                                                        ).copyWith(
                                                          fontFamily:
                                                              AppFonts.baloo2,
                                                          height: 1.1.h,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildSquadDetailContainer(
                                            context,
                                            title: "How many can join?",
                                            value:
                                                "${squadMission.maxUsers} people",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 23.h),
                            ]),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(height: 20.h),
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text:
                                      "More ${squad.name.capitalize} Squad  Missions",
                                  style: TextStyles.normalSemibold14(context),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        BlocBuilder<SquadIndividualBloc, SquadIndividualState>(
                          builder: (context, state) {
                            final squadMissions = state.missions
                                .where((e) => e.id != squadMission.id)
                                .toList();
                            bool isLoading =
                                state is SquadIndividualLoadingState &&
                                state.type == SquadIndividualType.fetch;
                            return MoreSquadMissionCard(
                              isLoading: isLoading,
                              squadMissions: squadMissions,
                              squad: squad,
                            );
                          },
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewPadding.top,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container _buildShareContainer(BuildContext context) {
    const double avatarSize = 35;
    const double overlap = 23;
    final shown = squad.members.take(3).toList();
    final double totalWidth = avatarSize + (shown.length - 1) * overlap;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white,
            hexToColor(squad.gradientColor.end),
            hexToColor(squad.gradientColor.start),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: avatarSize.h,
            width: totalWidth.w,
            child: Stack(
              children: List.generate(shown.length, (i) {
                return Positioned(
                  left: (i * overlap).w,
                  child: _buildBorderedAvatar(
                    imageUrl: shown[i].profileImage,
                    size: avatarSize,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "${squad.name} Squad",
                    style: TextStyles.titleSemiBold20(
                      context,
                    ).copyWith(height: 1.h, fontFamily: AppFonts.baloo2),
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Inspire other people, be at the top!",
                    style: TextStyles.smallRegular12(
                      context,
                    ).copyWith(height: 1.h, fontFamily: AppFonts.baloo2),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => SharePlus.instance.share(
                  ShareParams(
                    text: referralMessage(state.profile.referralCode),
                  ),
                ),
                child: Container(
                  width: 35.r,
                  height: 35.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 7.94.r,
                        color: AppColors.black10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedShare08,
                      size: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBorderedAvatar({
    required String? imageUrl,
    required double size,
  }) {
    return SizedBox(
      height: size.h,
      width: size.w,
      child: Stack(
        children: [
          Center(
            child: CachedImageRadius(
              imageUrl: imageUrl ?? "",
              circle: true,
              size: size,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white50, width: 3.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquadDetailContainer(
    BuildContext context, {
    required String title,
    String? value,
    Widget? valueWidget,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            text: TextSpan(
              text: title,
              style: TextStyles.smallRegular12(context),
            ),
          ),
          if (valueWidget != null)
            valueWidget
          else if (value != null)
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              text: TextSpan(
                text: value,
                style: TextStyles.bodySemiBold16(
                  context,
                ).copyWith(fontFamily: AppFonts.baloo2, height: 1.h),
              ),
            ),
        ],
      ),
    );
  }
}

class _CollapsedAppBar extends StatelessWidget {
  const _CollapsedAppBar({
    required bool isCollapsed,
    required this.squadMission,
  }) : _isCollapsed = isCollapsed;

  final bool _isCollapsed;
  final SquadMission squadMission;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isCollapsed ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: squadMission.title,
                style: TextStyles.bodyBold16(
                  context,
                ).copyWith(fontSize: 18.sp, fontFamily: AppFonts.baloo2),
              ),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: IconTextButton(
              height: 28,
              onPressed: () {
                if (squadMission.canJoin) {
                  context.read<SquadMissionBloc>().add(JoinSquadMissionEvent());
                } else if (squadMission.isJoined &&
                    squadMission.chatRoomId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<SquadMissionBloc>(),
                        child: SquadMissionChatPage(
                          mission: squadMission,
                          chatRoomId: squadMission.chatRoomId!,
                          onMissionSubmitted: () {
                            context.read<SquadIndividualBloc>().add(
                              FetchSquadMissionsEvent(),
                            );
                            context.read<RecentActivityBloc>().add(
                              FetchActivityEvent(),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
              text: squadMission.actionLabel,
              textSize: 8,
              color: squadMission.isJoined
                  ? AppColors.black
                  : squadMission.hasExpired || squadMission.isFull
                  ? AppColors.grey550
                  : AppColors.black,
              textColor: AppColors.white,
              paddingW: 0,
              paddingH: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedAppBar extends StatelessWidget {
  const _ExpandedAppBar({required this.squadMission, required bool isCollapsed})
    : _isCollapsed = isCollapsed;

  final SquadMission squadMission;
  final bool _isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedImageSize(
          imageUrl: squadMission.image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          color: AppColors.grey300.withValues(alpha: .25),
        ),
        Container(color: AppColors.black20),
        AnimatedOpacity(
          opacity: _isCollapsed ? 0.0 : 1.0,
          duration: Duration(milliseconds: 200),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button (white when expanded)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.black20,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft02,
                            color: Colors.white, // white when expanded
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // Bottom info container
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black40,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: squadMission.title,
                            style: TextStyles.titleBold20(context).copyWith(
                              fontSize: 18.sp,
                              height: 1.h,
                              fontFamily: AppFonts.baloo2,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: squadMission.subtitle,
                            style: TextStyles.smallMedium12(context).copyWith(
                              height: 1.h,
                              fontFamily: AppFonts.baloo2,
                              color: AppColors.white70,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<SquadMissionBloc, SquadMissionState>(
                          builder: (context, missionState) {
                            final isJoining =
                                missionState is SquadMissionLoadingState &&
                                missionState.type ==
                                    SquadMissionType.joinMission;

                            return IconTextButton(
                              onPressed: () {
                                if (squadMission.isJoined) {
                                  if (squadMission.chatRoomId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context
                                              .read<SquadMissionBloc>(),
                                          child: SquadMissionChatPage(
                                            mission: squadMission,
                                            chatRoomId:
                                                squadMission.chatRoomId!,
                                            onMissionSubmitted: () {
                                              context
                                                  .read<SquadIndividualBloc>()
                                                  .add(
                                                    FetchSquadMissionsEvent(),
                                                  );
                                              context
                                                  .read<RecentActivityBloc>()
                                                  .add(FetchActivityEvent());
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else if (squadMission.canJoin) {
                                  context.read<SquadMissionBloc>().add(
                                    JoinSquadMissionEvent(),
                                  );
                                }
                              },
                              height: 56,
                              text: squadMission.actionLabel,
                              buttonState: isJoining
                                  ? AppButtonState.loading
                                  : AppButtonState.idle,
                              color: _primaryButtonColor(squadMission),
                              textColor: _primaryButtonTextColor(squadMission),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _primaryButtonColor(SquadMission mission) {
    if (mission.isJoined) return AppColors.black;
    if (mission.hasExpired || mission.isFull) return AppColors.grey550;
    return AppColors.white;
  }

  Color _primaryButtonTextColor(SquadMission mission) {
    if (mission.isJoined) return AppColors.white;
    if (mission.hasExpired || mission.isFull) return AppColors.white;
    return AppColors.black;
  }
}

class MoreSquadMissionCard extends StatelessWidget {
  const MoreSquadMissionCard({
    super.key,
    required this.isLoading,
    required this.squadMissions,
    required this.squad,
  });

  final bool isLoading;
  final List<SquadMission> squadMissions;
  final Squad squad;

  @override
  Widget build(BuildContext context) {
    if (isLoading && squadMissions.isEmpty)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        sliver: SliverGrid.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  FadeShimmer(
                    width: double.infinity,
                    height: double.infinity,
                    baseColor: AppColors.darkPrimary05,
                    highlightColor: AppColors.grey300.withValues(alpha: .25),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.h,
                    ),
                    child: Column(
                      children: [
                        FadeShimmer(
                          width: double.infinity,
                          height: 14.h,
                          radius: 12.r,
                          baseColor: AppColors.darkPrimary05,
                          highlightColor: AppColors.grey300.withValues(
                            alpha: .25,
                          ),
                        ),
                        FadeShimmer(
                          width: double.infinity,
                          height: 14.h,
                          radius: 12.r,
                          baseColor: AppColors.darkPrimary05,
                          highlightColor: AppColors.grey300.withValues(
                            alpha: .25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 143.h,
            crossAxisSpacing: 6.5.w,
            mainAxisSpacing: 10.h,
          ),
        ),
      );
    else if (squadMissions.isEmpty)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: 100.h,
            child: Center(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "No Squad Missions",
                  style: TextStyles.smallSemibold12(context, opacity: .65),
                ),
              ),
            ),
          ),
        ),
      );
    else
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        sliver: SliverGrid.builder(
          itemCount: squadMissions.length,
          itemBuilder: (context, index) {
            final squadMission = squadMissions[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      // Pass the EXISTING instance — don't create a new one
                      BlocProvider.value(
                        value: context.read<SquadIndividualBloc>(),
                      ),
                      // Create a NEW scoped SquadMissionBloc for this page
                      BlocProvider<SquadMissionBloc>(
                        create: (_) => sl<SquadMissionBloc>(
                          param1: squad.id,
                          param2: squadMission.id,
                        ),
                      ),
                    ],
                    child: SquadMissionDetailsPage(
                      squad: squad,
                      squadMission: squadMission,
                    ),
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CachedImageSize(
                  imageUrl: squadMission.image,
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.grey300.withValues(alpha: .25),
                  fit: BoxFit.cover,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.black25,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 6.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.63.w,
                                vertical: 2.83.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.black40,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  width: .5.w,
                                  color: AppColors.primary,
                                ),
                              ),
                              child: Row(
                                spacing: 2.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AssetsPngImages.one50,
                                    height: 7.74.r,
                                    width: 7.74.r,
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text:
                                          "${formatAmount(squadMission.points)}",
                                      style: TextStyles.smallCardBold8(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "${squadMission.hashtags}",
                            style: TextStyles.smallSemibold12(context).copyWith(
                              fontFamily: AppFonts.baloo2,
                              height: 1.h,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 143.h,
            crossAxisSpacing: 6.5.w,
            mainAxisSpacing: 10.h,
          ),
        ),
      );
  }
}
