import 'dart:ui';

import 'package:bravoo/core/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../mission/data/model/community_mission_model.dart';
import '../../data/model/response/squad_mission_model.dart';

Future<dynamic> squadMissionInstructionDialog({
  required SquadMission squadMission,
  required VoidCallback onChatPressed,
  bool showChat = false,
}) async {
  return Get.dialog(
    name: "squad_mission_instruction_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    SquadMissionInstructionDialog(
      squadMission: squadMission,
      onChatPressed: onChatPressed,
      showChat: showChat,
    ),
  );
}

class SquadMissionInstructionDialog extends StatefulWidget {
  const SquadMissionInstructionDialog({
    super.key,
    required this.squadMission,
    required this.onChatPressed,
    required this.showChat,
  });

  final SquadMission squadMission;
  final VoidCallback onChatPressed;
  final bool showChat;

  @override
  State<SquadMissionInstructionDialog> createState() =>
      _SquadMissionInstructionDialogState();
}

class _SquadMissionInstructionDialogState
    extends State<SquadMissionInstructionDialog>
    with UIToolMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                              text: widget.squadMission.instructionTitle,
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
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.squadMission.instructions.length,
                        itemBuilder: (context, index) {
                          final instruction =
                              widget.squadMission.instructions[index];
                          bool isFirst = index == 0;
                          bool isLast =
                              index ==
                              widget.squadMission.instructions.length - 1;
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.redBrown5,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              width: 1.w,
                              color: AppColors.black10,
                            ),
                          ),
                          child: Row(
                            spacing: 4.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedAlertCircle,
                                size: 12.sp,
                                color: AppColors.redBrown50,
                              ),
                              RichText(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text:
                                      "Only the squad lead can submit the mission",
                                  style: TextStyles.smallRegular12(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    if (widget.showChat)
                      IconTextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onChatPressed();
                        },
                        text: "Go to Chat Room",
                        textColor: AppColors.white,
                        color: AppColors.black,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                  child: MarkdownBody(
                    data: instruction.text,
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
                      p: TextStyles.normalSemibold14(context),
                      strong: TextStyles.normalBold14(context),
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
              ],
            )
          : MarkdownBody(
              data: instruction.text,
              onTapLink: (text, href, title) async {
                if (href != null) {
                  final uri = Uri.parse(href);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              styleSheet: MarkdownStyleSheet(
                a: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
                p: TextStyles.normalSemibold14(context),
                strong: TextStyles.normalBold14(context),
              ),
            ),
    );
  }
}
