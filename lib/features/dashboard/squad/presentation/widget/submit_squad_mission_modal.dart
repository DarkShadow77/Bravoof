import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

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
    SubmitSquadMissionModal(onPressed: onPressed, submissionType: submissionType),
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
  State<SubmitSquadMissionModal> createState() => _SubmitSquadMissionModalState();
}

class _SubmitSquadMissionModalState extends State<SubmitSquadMissionModal> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  String? pickedImage;

  bool get isPhoto => widget.submissionType == 'photo';

  bool get canSubmit =>
      isPhoto ? pickedImage != null : _textController.text.trim().isNotEmpty;

  String get _submissionValue =>
      isPhoto ? pickedImage! : _textController.text.trim();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => pickedImage = pickedFile.path);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      maxHeight: isPhoto ? 400.h : 480.h,
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
                text: isPhoto
                    ? "Upload your image as screenshot below:"
                    : "Type your answer below:",
                style: TextStyles.normalSemibold14(context),
              ),
            ),
            SizedBox(height: 36.h),
            if (isPhoto)
              GestureDetector(
                onTap: pickImage,
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
                      RichText(
                        text: TextSpan(
                          text: pickedImage != null
                              ? shortenFileName(p.basename(pickedImage!))
                              : "Click to upload your image",
                          style: TextStyles.smallSemibold12(
                            context,
                          ).copyWith(color: AppColors.grey400),
                        ),
                      ),
                      HugeIcon(icon: HugeIcons.strokeRoundedImageCrop),
                    ],
                  ),
                ),
              )
            else
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
