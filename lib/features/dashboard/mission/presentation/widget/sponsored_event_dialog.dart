import 'dart:ui';

import 'package:flowva/core/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../common/Mission_success.dart';
import '../../../../common/flowva_button.dart';
import '../../../../common/helper.dart';
import '../../data/model/community_mission_model.dart';
import '../../data/model/sponsored_mission_model.dart';
import '../bloc/sponsored_mission_bloc.dart';

Future<dynamic> sponsoredEventDialog({
  required SponsoredMission sponsoredMission,
}) async {
  return Get.dialog(
    name: "sponsored_event_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    SponsoredEventDialog(sponsoredMission: sponsoredMission),
  );
}

class SponsoredEventDialog extends StatefulWidget {
  const SponsoredEventDialog({super.key, required this.sponsoredMission});

  final SponsoredMission sponsoredMission;

  @override
  State<SponsoredEventDialog> createState() => _AskingDialogState();
}

class _AskingDialogState extends State<SponsoredEventDialog> with UIToolMixin {
  final ImagePicker _picker = ImagePicker();

  String? pickedImage;

  pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);

      setState(() {
        pickedImage = pickedFile!.path;
      });
    } catch (e) {
      print(e);
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<SponsoredMissionBloc, SponsoredMissionState>(
        listener: (context, state) {
          if (state is SponsoredMissionLoading &&
              state.type == SponsoredMissionType.completeMission &&
              state.missionId == widget.sponsoredMission.id) {
            outerLoadingDialog(text: "Completing Mission");
          }
          if (state is SponsoredMissionError &&
              state.type == SponsoredMissionType.completeMission &&
              state.missionId == widget.sponsoredMission.id) {
            if (Get.isDialogOpen ?? false) Get.back();
            showMessage(
              state.message,
              context,
              color: Colors.red,
              styleColor: Colors.white,
              status: true,
            );
          }

          if (state is SponsoredMissionJoined &&
              state.missionId == widget.sponsoredMission.id) {
            if (Get.isDialogOpen ?? false) Get.back();
            if (Get.isDialogOpen ?? false) Get.back();
            context.read<SponsoredMissionBloc>().add(LoadSponsoredMission());
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
                    "Once we confirm it, your reward will be added to your account within 5 days.",
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
                                text: widget.sponsoredMission.instructionTitle,
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
                        itemCount: widget.sponsoredMission.instructions.length,
                        itemBuilder: (context, index) {
                          final instruction =
                              widget.sponsoredMission.instructions[index];
                          bool isFirst = index == 0;
                          bool isLast =
                              index ==
                              widget.sponsoredMission.instructions.length - 1;
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
                      pickedImage != null
                          ? FlowvaButton.blueButton(
                              name: "Mission complete",
                              apply: () {
                                BlocProvider.of<SponsoredMissionBloc>(
                                  context,
                                ).add(
                                  CompleteSponsoredMission(
                                    missionId: widget.sponsoredMission.id,
                                    imageUrl: pickedImage,
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
                  child: Linkify(
                    text: instruction.text,
                    style: TextStyles.normalSemibold14(context),
                    linkStyle: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                    onOpen: (link) async {
                      final uri = Uri.parse(link.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Divider(
                    height: 1,
                    color: AppColors.grey300.withValues(alpha: .5),
                  ),
                ),

                GestureDetector(
                  onTap: () => pickImage(ImageSource.gallery),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFFE9E9E9)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pickedImage != null
                              ? '${shortenFileName(p.basename(pickedImage!))}'
                              : "Upload screenshot",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        HugeIcon(icon: HugeIcons.strokeRoundedImageCrop),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Linkify(
              text: instruction.text,
              style: TextStyles.normalSemibold14(context),
              linkStyle: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
              onOpen: (link) async {
                final uri = Uri.parse(link.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
    );
  }
}
