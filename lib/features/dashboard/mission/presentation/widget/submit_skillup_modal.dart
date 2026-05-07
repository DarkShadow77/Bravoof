import 'dart:io';

import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../common/flowva_text_field.dart';
import '../../../squad/presentation/widget/submit_squad_mission_modal.dart';

Future submitSkillUpModal({
  required Function(String?) onPressed,
  required String submissionType,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    SubmitSkillUpModal(onPressed: onPressed, submissionType: submissionType),
  );
}

class SubmitSkillUpModal extends StatefulWidget {
  const SubmitSkillUpModal({
    super.key,
    required this.onPressed,
    required this.submissionType,
  });

  final Function(String?) onPressed;
  final String submissionType;

  @override
  State<SubmitSkillUpModal> createState() => _SubmitSkillUpModalState();
}

class _SubmitSkillUpModalState extends State<SubmitSkillUpModal> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  String? _pickedFilePath;

  bool get isPhoto => widget.submissionType == 'photo';
  bool get isVideo => widget.submissionType == 'video';

  bool get canSubmit => isPhoto || isVideo
      ? _pickedFilePath != null
      : _textController.text.trim().isNotEmpty;

  String get _submissionValue =>
      isPhoto || isVideo ? _pickedFilePath! : _textController.text.trim();

  VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  @override
  void dispose() {
    _textController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  pickImage() async {
    try {
      XFile? file;
      if (isVideo) {
        file = await _picker.pickVideo(source: ImageSource.gallery);
      } else {
        file = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      }

      if (file == null) return;

      // Dispose previous video controller
      await _videoController?.dispose();
      _videoController = null;

      setState(() {
        _pickedFilePath = file!.path;
        _videoInitialized = false;
      });

      if (isVideo) {
        final controller = VideoPlayerController.file(File(file.path));
        _videoController = controller;
        await controller.initialize();
        setState(() => _videoInitialized = true);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 52.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 23.h),
            Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 21.r,
                  width: 21.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(width: 0.2, color: AppColors.black60),
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    behavior: HitTestBehavior.opaque,
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      size: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 23.h),
            RichText(
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "Submit Your Work",
                style: TextStyles.titleRegular20(
                  context,
                ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
              ),
            ),
            SizedBox(height: 23.h),
            RichText(
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: isPhoto || isVideo
                    ? "Upload your ${isPhoto ? "image" : "video"} as evidence below:"
                    : "Type your answer below:",
                style: TextStyles.normalSemibold14(context),
              ),
            ),
            SizedBox(height: 36.h),
            if (isPhoto || isVideo) ...[
              if (_pickedFilePath != null)
                MediaPreview(
                  filePath: _pickedFilePath!,
                  isVideo: isVideo,
                  videoController: _videoInitialized ? _videoController : null,
                  onRemove: () {
                    _videoController?.dispose();
                    setState(() {
                      _pickedFilePath = null;
                      _videoController = null;
                      _videoInitialized = false;
                    });
                  },
                )
              else
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Color(0xFFFE9E9E9)),
                    ),
                    child: Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedImageCrop,
                          size: 32.sp,
                          color: AppColors.grey400,
                        ),
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: _pickedFilePath != null
                                  ? shortenFileName(
                                      p.basename(_pickedFilePath!),
                                    )
                                  : "Tap to upload photo or video",
                              style: TextStyles.smallSemibold12(
                                context,
                              ).copyWith(color: AppColors.grey400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_pickedFilePath != null) ...[
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedRefresh,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      RichText(
                        text: TextSpan(
                          text: "Change file",
                          style: TextStyles.smallSemibold12(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else
              AppTextFeild(
                maxLines: 4,
                controller: _textController,
                hintText: "Write your answer here...",
                validator: MultiValidator([
                  RequiredValidator(errorText: "Answer is required"),
                ]).call,
                onChanged: (value) => setState(() {}),
              ),
            SizedBox(height: 36.h),
            IconTextButton(
              color: canSubmit ? AppColors.black : AppColors.grey300,
              textColor: AppColors.white,
              onPressed: canSubmit
                  ? () => widget.onPressed(_submissionValue)
                  : () {},
              text: "Submit mission ✅",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
