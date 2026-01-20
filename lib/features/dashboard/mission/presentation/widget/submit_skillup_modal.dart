import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../common/helper.dart';

Future submitSkillUpModal({required Function(String?) onPressed}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    SubmitSkillUpModal(onPressed: onPressed),
  );
}

class SubmitSkillUpModal extends StatefulWidget {
  const SubmitSkillUpModal({super.key, required this.onPressed});

  final Function(String?) onPressed;

  @override
  State<SubmitSkillUpModal> createState() => _SubmitSkillUpModalState();
}

class _SubmitSkillUpModalState extends State<SubmitSkillUpModal> {
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
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      maxHeight: 400.h,
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
                    onTap: () => Get.back(),
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
                text: "Upload your image as screenshot below:",
                style: TextStyles.normalSemibold14(context),
              ),
            ),
            SizedBox(height: 36.h),
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
                    RichText(
                      text: TextSpan(
                        text: pickedImage != null
                            ? '${shortenFileName(p.basename(pickedImage!))}'
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
            ),
            SizedBox(height: 36.h),
            pickedImage != null
                ? IconTextButton(
                    color: AppColors.black,
                    textColor: AppColors.white,
                    onPressed: () => widget.onPressed(pickedImage),
                    text: "Submit mission ✅",
                  )
                : IconTextButton(
                    color: AppColors.grey300,
                    textColor: AppColors.white,
                    onPressed: () {},
                    text: "Submit mission ✅",
                  ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
