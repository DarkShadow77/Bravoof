import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../core/model/version_model.dart';
import '../../../../core/services/version_service.dart';

Future optionalUpdateModal({
  required VersionCheckResult result,
  required VersionCheckService service,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: false,
    enableDrag: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    OptionalUpdateModal(result: result, service: service),
  );
}

class OptionalUpdateModal extends StatefulWidget {
  const OptionalUpdateModal({
    super.key,
    required this.result,
    required this.service,
  });

  final VersionCheckResult result;
  final VersionCheckService service;

  @override
  State<OptionalUpdateModal> createState() => _OptionalUpdateModalState();
}

class _OptionalUpdateModalState extends State<OptionalUpdateModal> {
  @override
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            SizedBox(height: 10.h),
            Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: widget.result.title ?? 'Update Available',
                      style: TextStyles.titleSemiBold20(context),
                    ),
                  ),
                ),
                Container(
                  height: 36.r,
                  width: 36.r,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.black03,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: AppColors.black05),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),

                    icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            RichText(
              text: TextSpan(
                text: widget.result.message ?? "A new version is available",
                style: TextStyles.normalRegular14(context),
              ),
            ),
            SizedBox(height: 16.h),
            IconTextButton(
              height: 40,
              onPressed: () => Navigator.pop(context),
              text: "Later",
              color: Colors.transparent,
              textColor: AppColors.white,
            ),
            SizedBox(height: 8.h),
            IconTextButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  await widget.service.checkAndPerformInAppUpdate();
                } else {
                  await widget.service.openStore(widget.result.storeUrl);
                }
                if (mounted) Navigator.pop(context);
              },
              text: "Update",
              color: AppColors.black,
              textColor: AppColors.white,
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

Future forceUpdateModal({
  required VersionCheckResult result,
  required VersionCheckService service,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    ForceUpdateModal(result: result, service: service),
  );
}

class ForceUpdateModal extends StatefulWidget {
  const ForceUpdateModal({
    super.key,
    required this.result,
    required this.service,
  });

  final VersionCheckResult result;
  final VersionCheckService service;

  @override
  State<ForceUpdateModal> createState() => _ForceUpdateModalState();
}

class _ForceUpdateModalState extends State<ForceUpdateModal> with UIToolMixin {
  @override
  Widget build(BuildContext ctx) {
    return PopScope(
      canPop: false,
      child: ShowModalSheet(
        maxHeight: 600.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              SizedBox(height: 10.h),
              Row(
                spacing: 20.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: widget.result.title ?? 'Update Required',
                        style: TextStyles.titleSemiBold20(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              RichText(
                text: TextSpan(
                  text: widget.result.message ?? 'Please update to continue',
                  style: TextStyles.normalRegular14(context),
                ),
              ),
              SizedBox(height: 16.h),
              IconTextButton(
                onPressed: () =>
                    widget.service.openStore(widget.result.storeUrl),
                text: "Update Now",
                color: AppColors.black,
                textColor: AppColors.white,
              ),
              SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
