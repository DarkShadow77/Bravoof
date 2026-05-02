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

Future submitSquadMissionModal({
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
    SubmitSquadMissionModal(
      onPressed: onPressed,
      submissionType: submissionType,
    ),
  );
}

class SubmitSquadMissionModal extends StatefulWidget {
  const SubmitSquadMissionModal({
    super.key,
    required this.onPressed,
    required this.submissionType,
  });

  final Function(String?) onPressed;
  final String submissionType;

  @override
  State<SubmitSquadMissionModal> createState() =>
      _SubmitSquadMissionModalState();
}

class _SubmitSquadMissionModalState extends State<SubmitSquadMissionModal> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  String? _pickedFilePath;

  bool get isVideo => widget.submissionType == 'video';
  bool get isPhoto => widget.submissionType == 'photo';

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
                _MediaPreview(
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
                onChanged: (value) {
                  setState(() {});
                },
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

class _MediaPreview extends StatefulWidget {
  const _MediaPreview({
    required this.filePath,
    required this.isVideo,
    required this.videoController,
    required this.onRemove,
  });

  final String filePath;
  final bool isVideo;
  final VideoPlayerController? videoController;
  final VoidCallback onRemove;

  @override
  State<_MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<_MediaPreview> {
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    // Max height for the preview — keeps the modal from exploding
    const double maxPreviewHeight = 200;

    Widget mediaWidget;

    if (widget.isVideo) {
      if (widget.videoController != null) {
        final ratio = widget.videoController!.value.aspectRatio;
        mediaWidget = LayoutBuilder(
          builder: (context, constraints) {
            // Width is constrained by the modal; derive height from ratio
            final derivedHeight = constraints.maxWidth / ratio;
            // Clamp so it never exceeds maxPreviewHeight
            final clampedHeight = derivedHeight.clamp(80.0, maxPreviewHeight);
            return SizedBox(
              width: double.infinity,
              height: clampedHeight,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: widget.videoController!.value.size.width,
                  height: widget.videoController!.value.size.height,
                  child: VideoPlayer(widget.videoController!),
                ),
              ),
            );
          },
        );
      } else {
        mediaWidget = Container(
          height: maxPreviewHeight,
          color: AppColors.grey200,
          child: const Center(child: CircularProgressIndicator()),
        );
      }
    } else {
      // Photo — fixed height, cover fit, no aspect ratio weirdness
      mediaWidget = SizedBox(
        width: double.infinity,
        height: maxPreviewHeight,
        child: Image.file(File(widget.filePath), fit: BoxFit.cover),
      );
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: mediaWidget,
        ),
        // Video play/pause overlay
        if (widget.isVideo && widget.videoController != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _playing = !_playing;
                  if (_playing) {
                    widget.videoController!.play();
                  } else {
                    widget.videoController!.pause();
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _playing ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: AppColors.black40,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.white,
                        size: 28.r,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Remove button
        Positioned(
          top: 8.r,
          right: 8.r,
          child: GestureDetector(
            onTap: widget.onRemove,
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: AppColors.black60,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.white,
                size: 16.r,
              ),
            ),
          ),
        ),
        // File name tag
        Positioned(
          bottom: 8.r,
          left: 8.r,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.black60,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                  color: AppColors.white,
                  size: 12.r,
                ),
                SizedBox(width: 4.w),
                RichText(
                  text: TextSpan(
                    text: shortenFileName(p.basename(widget.filePath)),
                    style: TextStyles.smallSemibold12(
                      context,
                    ).copyWith(color: AppColors.white, fontSize: 10.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
