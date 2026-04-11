import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../app/styles/text_styles.dart';
import '../../../../../../app/view/widgets/gradient_progress.dart';
import '../../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/fonts.dart';
import '../../../../../../utility/ui_tool_mix.dart';
import '../../../data/model/mission_status_enum.dart';
import '../../../data/model/skill_up_mission_model.dart';
import '../../bloc/skill_up_bloc.dart';
import '../../widget/skill_up_success_dialog.dart';
import '../../widget/submit_skillup_modal.dart';
import '../../widget/unlock_skillup_mission_modal.dart';
import 'content_screen.dart';

class SkillUpScreen extends StatefulWidget {
  final SkillUpMission skill;
  final int index;

  SkillUpScreen({required this.skill, required this.index, super.key});

  @override
  State<SkillUpScreen> createState() => _SkillUpScreenState();
}

class _SkillUpScreenState extends State<SkillUpScreen> with UIToolMixin {
  late SkillUpMission skill;

  @override
  void initState() {
    super.initState();
    skill = widget.skill;
  }

  _loadingState(BuildContext context, SkillUpLoading state, int stepId) {
    if ((state.type == SkillUpType.completeMission &&
            state.missionId == skill.id) ||
        (state.type == SkillUpType.unlockSkillUp &&
            state.missionId == stepId)) {
      outerLoadingDialog(text: "Completing Skill Up Mission");
    }
  }

  _successState(
    BuildContext context,
    SkillUpCompleted state,
    int stepId,
    bool isLast,
  ) {
    if (state.missionId == skill.id && state.stepId == stepId) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<SkillUpBloc>().add(LoadSkillUpMission());
      skillUpSuccessDialog(isLast: isLast);
    }
  }

  _unlockedState(
    BuildContext context,
    SkillUpUnlocked state,
    SkillUpStep mission,
  ) {
    if (state.stepId == mission.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<SkillUpBloc>().add(LoadSkillUpMission());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ContentScreen(
            mission: mission,
            content: mission.contentOne!,
            mainPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ContentScreen(
                    mission: mission,
                    content: mission.contentTwo!,
                    mainPressed: () {
                      submitSkillUpModal(
                        submissionType: mission.submissionType,
                        onPressed: (value) {
                          if (value != null) {
                            context.read<SkillUpBloc>().add(
                              CompleteSkillUpMission(
                                missionId: skill.id,
                                stepId: mission.id,
                                imageUrl: mission.isPhotoSubmission
                                    ? value
                                    : null,
                                evidenceText: mission.isTextSubmission
                                    ? value
                                    : null,
                              ),
                            );
                          }
                        },
                      );
                    },
                    subPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    mainText: "Share your creation",
                    subText: "End Mission",
                    progress: 100 / 100,
                  ),
                ),
              );
            },
            subPressed: () {
              Navigator.pop(context);
            },
            mainText: "I'm ready",
            subText: "End Mission",
            progress: 50 / 100,
          ),
        ),
      );
    }
  }

  _failureState(BuildContext context, SkillUpError state, int stepId) {
    if ((state.type == SkillUpType.completeMission &&
            state.missionId == skill.id) ||
        (state.type == SkillUpType.unlockSkillUp &&
            state.missionId == stepId)) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.red,
        styleColor: Colors.white,
        status: true,
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: kToolbarHeight,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: skill.steps.length,
                    itemBuilder: (context, index) {
                      final mission = skill.steps[index];
                      bool isLast = mission == skill.steps.last;
                      return BlocConsumer<SkillUpBloc, SkillUpState>(
                        listener: (context, state) {
                          if (state is SkillUpLoading) {
                            _loadingState(context, state, mission.id);
                          }
                          if (state is SkillUpCompleted) {
                            _successState(context, state, mission.id, isLast);
                          }
                          if (state is SkillUpUnlocked) {
                            _unlockedState(context, state, mission);
                          }
                          if (state is SkillUpError) {
                            _failureState(context, state, mission.id);
                          }
                        },
                        builder: (context, state) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              skill = state.missions.firstWhere(
                                (e) => e.id == skill.id,
                              );
                            });
                          });

                          return SkillMissionCard(
                            mission: mission,
                            isLast: isLast,
                            skill: skill,
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(height: 16.h),
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

class SkillMissionCard extends StatelessWidget with UIToolMixin {
  const SkillMissionCard({
    super.key,
    required this.mission,
    required this.isLast,
    required this.skill,
  });

  final SkillUpStep mission;
  final bool isLast;
  final SkillUpMission skill;

  String formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;

    if (days > 0) return "$days day${days > 1 ? 's' : ''}";
    return "$hours hour${hours > 1 ? 's' : ''}";
  }

  @override
  Widget build(BuildContext context) {
    bool notJoined =
        mission.status == MissionStatus.notJoined ||
        mission.status == MissionStatus.rejected;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white50,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(.92, 1.8),
            blurRadius: 4.6.r,
            color: Color(0xff9E9A9A).withValues(alpha: .1),
          ),
          BoxShadow(
            offset: Offset(2.8, 8.3),
            blurRadius: 9.19.r,
            color: Color(0xff9E9A9A).withValues(alpha: .09),
          ),
          BoxShadow(
            offset: Offset(7.35, 18.38),
            blurRadius: 11.95.r,
            color: Color(0xff9E9A9A).withValues(alpha: .05),
          ),
          BoxShadow(
            offset: Offset(12, 33),
            blurRadius: 13.79.r,
            color: Color(0xff9E9A9A).withValues(alpha: .01),
          ),
        ],
        border: Border.all(width: 1.5.r, color: AppColors.white50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 6.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GradientProgress(
                  height: 14,
                  progress: (notJoined ? 10 : 100) / 100,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xffF5EBFF),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  spacing: 4.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/one_50.png",
                      height: 11.5.r,
                      width: 11.5.r,
                    ),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "+${mission.minPoints}-${mission.maxPoints}",
                        style: TextStyles.cardBold10(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Mission ${mission.stepOrder}",
              style: TextStyles.titleRegular20(
                context,
              ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
            ),
          ),
          SizedBox(height: 15.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: mission.title,
              style: TextStyles.bodySemiBold16(context),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              spacing: 30.h,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: mission.subject,
                    style: TextStyles.normalRegular14(context),
                  ),
                ),
                if (mission.locked &&
                    mission.isUnlocked &&
                    mission.unlockTimeLeft != null)
                  Text(
                    "Unlocked • ${formatDuration(mission.unlockTimeLeft!)} left",
                    style: TextStyles.smallRegular12(context, opacity: 0.6),
                  ),
                if (mission.isUnlocked) ...[
                  if (notJoined)
                    IconTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ContentScreen(
                              mission: mission,
                              content: mission.contentOne!,
                              mainPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => ContentScreen(
                                      mission: mission,
                                      content: mission.contentTwo!,
                                      mainPressed: () {
                                        submitSkillUpModal(
                                          submissionType:
                                              mission.submissionType,
                                          onPressed: (value) {
                                            if (value != null) {
                                              context.read<SkillUpBloc>().add(
                                                CompleteSkillUpMission(
                                                  missionId: skill.id,
                                                  stepId: mission.id,
                                                  imageUrl:
                                                      mission.isPhotoSubmission
                                                      ? value
                                                      : null,
                                                  evidenceText:
                                                      mission.isTextSubmission
                                                      ? value
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      subPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      mainText: "Share your creation",
                                      subText: "End Mission",
                                      progress: 100 / 100,
                                    ),
                                  ),
                                );
                              },
                              subPressed: () {
                                Navigator.pop(context);
                              },
                              mainText: "I'm ready",
                              subText: "End Mission",
                              progress: 50 / 100,
                            ),
                          ),
                        );
                      },
                      color: AppColors.black,
                      text: "Start Mission",
                      textColor: AppColors.white,
                    )
                  else
                    IconTextButton(
                      onPressed: () {
                        showMessage(
                          "Mission Already Completed",
                          context,
                          color: Colors.white,
                          styleColor: Colors.black,
                        );
                      },
                      color: AppColors.grey400.withValues(alpha: .85),
                      borderColor: AppColors.grey400.withValues(alpha: .15),
                      text: "Mission Completed",
                      textColor: AppColors.white50,
                    ),
                ] else
                  IconTextButton(
                    onPressed: () {
                      unlockSkillUpMissionModal(
                        onCoin: () {
                          context.read<SkillUpBloc>().add(
                            UnlockSkillUpMission(
                              stepId: mission.id,
                              source: UnlockSource.coins,
                            ),
                          );
                        },
                        onVideo: () {
                          context.read<SkillUpBloc>().add(
                            UnlockSkillUpMission(
                              stepId: mission.id,
                              source: UnlockSource.video,
                            ),
                          );
                        },
                      );
                    },
                    color: AppColors.black,
                    text: "Unlock Mission",
                    icon: AssetsSvgIcons.circleLock,
                    textColor: AppColors.white,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
