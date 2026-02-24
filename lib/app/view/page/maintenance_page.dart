import 'dart:io';

import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/model/version_model.dart';
import '../../styles/text_styles.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key, required this.result});

  final VersionCheckResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsPngImages.maintenance,
              width: 142.w,
              height: 102.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              height: 400.h,
              padding: EdgeInsets.symmetric(horizontal: 44.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white20,
                borderRadius: BorderRadius.circular(32.r),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AssetsPngImages.maintenanceBg),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: result.title ?? 'Bravoo Under Maintenance',
                      style: TextStyles.h2Bold32(context).copyWith(
                        fontFamily: AppFonts.baloo2,
                        color: AppColors.white,
                        height: 1.sp,
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text:
                          result.message ??
                          'We’re currently performing maintenance to improve your experience and will be back shortly. Thank you for your patience',
                      style: TextStyles.bodyMedium16(
                        context,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            IconTextButton(
              height: 56,
              onPressed: () => exit(0),
              text: "Sounds good",
              color: AppColors.black,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
