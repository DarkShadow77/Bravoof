import 'dart:ui';

import 'package:flowva/core/constants/fonts.dart';
import 'package:flowva/features/mission/data/model/community_mission_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../utility/ui_tool_mix.dart';
import '../../../common/Mission_success.dart';
import '../../../common/flowva_button.dart';
import '../../../common/flowva_text_field.dart';
import '../../data/model/social_mission_model.dart';
import '../bloc/social_mission_bloc.dart';

Future<dynamic> socialEventDialog({
  required SocialMission socialMission,
}) async {
  return Get.dialog(
    name: "social_event_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    SocialEventDialog(socialMission: socialMission),
  );
}

class SocialEventDialog extends StatefulWidget {
  const SocialEventDialog({super.key, required this.socialMission});

  final SocialMission socialMission;

  @override
  State<SocialEventDialog> createState() => _AskingDialogState();
}

class _AskingDialogState extends State<SocialEventDialog> with UIToolMixin {
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<SocialMissionBloc, SocialMissionState>(
        listener: (context, state) {
          if (state is SocialMissionLoading &&
              state.type == SocialMissionType.completeMission &&
              state.missionId == widget.socialMission.id) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black.withValues(alpha: 0.3),
              builder: (_) => Center(
                child: Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    backgroundColor: Color(0xff828282),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF9013FE),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            );
          }
          if (state is SocialMissionError &&
              state.type == SocialMissionType.completeMission &&
              state.missionId == widget.socialMission.id) {
            Get.back();
            showMessage(
              state.message,
              context,
              color: Colors.red,
              styleColor: Colors.white,
              status: true,
            );
          }

          if (state is SocialMissionJoined &&
              state.missionId == widget.socialMission.id) {
            Get.back();
            Get.back();
            BlocProvider.of<SocialMissionBloc>(
              context,
            ).add(LoadSocialMission());
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              builder: (_) => MissionSuccess(
                title: "Thank you for your submission. ",
                bodyText:
                    "Once we confirm it, your reward will be added to your account.",
                b_text: "Back to missions",
              ),
            );
          }
        },
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: Colors.black.withValues(alpha: 0.2)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white85,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0,
                            child: Container(
                              height: 32.r,
                              width: 32.r,

                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(120),
                                border: Border.all(
                                  width: 0.2,
                                  color: AppColors.black60,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedCancel01,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.socialMission.instructionTitle,
                                style: TextStyles.bigTitleBold24(
                                  context,
                                ).copyWith(fontFamily: AppFonts.baloo2),
                              ),
                            ),
                          ),
                          Container(
                            height: 32.r,
                            width: 32.r,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(120),
                              border: Border.all(
                                width: 0.2,
                                color: AppColors.black60,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedCancel01,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.socialMission.instructions.length,
                        itemBuilder: (context, index) {
                          final instruction =
                              widget.socialMission.instructions[index];
                          bool isFirst = index == 0;
                          bool isLast =
                              index ==
                              widget.socialMission.instructions.length - 1;
                          return TimelineTile(
                            nodePosition: 0,
                            nodeAlign: TimelineNodeAlign.basic,
                            contents: _buildContextTile(
                              context,
                              instruction: instruction,
                              isLast: isLast,
                            ),
                            node: TimelineNode(
                              indicatorPosition: .3,
                              position: 0,
                              startConnector: isFirst
                                  ? null
                                  : DashedLineConnector(
                                      color: AppColors.grey300,
                                    ),
                              indicator: Container(
                                width: 24.r,
                                height: 24.r,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "${index + 1}",
                                      style: TextStyles.normalBold14(context)
                                          .copyWith(
                                            color: AppColors.white,
                                            fontFamily: AppFonts.baloo,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              endConnector: isLast
                                  ? null
                                  : DashedLineConnector(
                                      color: AppColors.grey300,
                                    ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                      answerController.text.trim().isNotEmpty
                          ? FlowvaButton.blueButton(
                              name: "Mission complete",
                              apply: () {
                                BlocProvider.of<SocialMissionBloc>(context).add(
                                  CompleteSocialMission(
                                    missionId: widget.socialMission.id,
                                    text: answerController.text.trim(),
                                  ),
                                );
                              },
                            )
                          : SizedBox(
                              height: 60,
                              child: FlowvaButton.inactiveButton(
                                name: "Mission complete",
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextTile(
    BuildContext context, {
    required MissionInstruction instruction,
    required bool isLast,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.w, bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: isLast
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      width: 1.r,
                      color: AppColors.grey300.withValues(alpha: .5),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: instruction.text,
                      style: TextStyles.normalSemibold14(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Divider(
                    height: 1,
                    color: AppColors.grey300.withValues(alpha: .5),
                  ),
                ),
                AppTextFeild(
                  controller: answerController,
                  hintText: "Type your answer here",
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Answer is required"),
                  ]).call,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            )
          : RichText(
              text: TextSpan(
                text: instruction.text,
                style: TextStyles.normalSemibold14(context),
              ),
            ),
    );
  }
}
