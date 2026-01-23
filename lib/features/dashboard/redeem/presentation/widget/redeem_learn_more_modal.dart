import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';

Future redeemLearnMoreModal({required String image}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    RedeemLearnMoreModal(image: image),
  );
}

class RedeemLearnMoreModal extends StatefulWidget {
  const RedeemLearnMoreModal({super.key, required this.image});

  final String image;

  @override
  State<RedeemLearnMoreModal> createState() => _RedeemLearnMoreModalState();
}

class _RedeemLearnMoreModalState extends State<RedeemLearnMoreModal> {
  @override
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(height: 47.h),
            Image.asset(
              widget.image,
              width: 118.w,
              height: 118.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 32.h),
            RichText(
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "How Reward Works on Bravoo!",
                style: TextStyles.normalBold14(context),
              ),
            ),
            SizedBox(height: 19.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "Points earned on Bravoo can be redeemed for \$5 airtime, "
                    "\$5 data or \$10 gift cards. Once redeemed, your reward is "
                    "verified and credited to the details you provided within 7 days!",
                style: TextStyles.bodyMedium16(
                  context,
                ).copyWith(fontFamily: AppFonts.baloo2, height: 1.sp),
              ),
            ),
            SizedBox(height: 32.h),
            IconTextButton(
              color: AppColors.black,
              textColor: AppColors.white,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              text: "Close",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
