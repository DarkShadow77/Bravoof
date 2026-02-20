import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/model/version_model.dart';
import '../../../styles/text_styles.dart';
import '../button/icon_text_button.dart';

Future maintenanceDialog({required VersionCheckResult result}) async {
  return Get.dialog(
    name: "maintenance_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    MaintenanceDialog(result: result),
  );
}

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({super.key, required this.result});

  final VersionCheckResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: AppColors.black.withValues(alpha: 0.2)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.h),
                    // Icon
                    Center(
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppColors.redBrown11,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCopyLink,
                            color: AppColors.redBrown50,
                            size: 24.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Title
                    RichText(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: result.title ?? 'Under Maintenance',
                        style: TextStyles.bigTitleBold24(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: result.message ?? 'Please check back soon',
                        style: TextStyles.smallMedium12(context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    IconTextButton(
                      height: 48,
                      color: AppColors.black,
                      textColor: AppColors.white,
                      onPressed: () => exit(0),
                      text: "Exit",
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
}
