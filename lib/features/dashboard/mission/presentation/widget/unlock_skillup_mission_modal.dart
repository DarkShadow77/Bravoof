import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';

Future unlockSkillUpMissionModal({
  required VoidCallback onCoin,
  required VoidCallback onVideo,
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
    UnlockSkillUpMissionModal(onCoin: onCoin, onVideo: onVideo),
  );
}

class UnlockSkillUpMissionModal extends StatefulWidget {
  const UnlockSkillUpMissionModal({
    super.key,
    required this.onCoin,
    required this.onVideo,
  });

  final VoidCallback onCoin;
  final VoidCallback onVideo;

  @override
  State<UnlockSkillUpMissionModal> createState() =>
      _UnlockSkillUpMissionModalState();
}

class _UnlockSkillUpMissionModalState extends State<UnlockSkillUpMissionModal> {
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
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Unlock your next mission",
                style: TextStyles.titleRegular20(
                  context,
                ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
              ),
            ),
            SizedBox(height: 23.h),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text:
                    "Unlock it your way by watching a short video or using your coins. Must be completed within 30 days.",
                style: TextStyles.normalSemibold14(context),
              ),
            ),
            SizedBox(height: 36.h),
            IconTextButton(
              onPressed: widget.onCoin,
              text: "Use your coins (5 Coins)",
            ),
            SizedBox(height: 12.h),
            IconTextButton(
              color: AppColors.primary,
              textColor: AppColors.white,
              onPressed: widget.onVideo,
              text: "Watch a video",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
