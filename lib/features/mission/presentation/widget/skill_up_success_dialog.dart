import 'dart:ui';

import 'package:flowva/app/view/widgets/button/icon_text_button.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../utility/ui_tool_mix.dart';

Future<dynamic> skillUpSuccessDialog({required bool isLast}) async {
  return Get.dialog(
    name: "skill_up_success_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    SkillUpSuccessDialog(isLast: isLast),
  );
}

class SkillUpSuccessDialog extends StatefulWidget {
  const SkillUpSuccessDialog({super.key, required this.isLast});

  final bool isLast;

  @override
  State<SkillUpSuccessDialog> createState() => _AskingDialogState();
}

class _AskingDialogState extends State<SkillUpSuccessDialog> with UIToolMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (canPop, result) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
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
                      SizedBox(height: 10.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Nice work!",
                          style: TextStyles.bigTitleBold24(
                            context,
                          ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Image.asset(
                        AssetsPngImages.roundedCheck,
                        width: 114.w,
                        height: 114.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 8.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: widget.isLast
                              ? "You have completed all current missions. New ones are coming! Your reward will appear in your account after confirmation."
                              : "Your reward will appear in your account after confirmation.",
                          style: TextStyles.bodySemiBold16(context),
                        ),
                      ),
                      SizedBox(height: 27.h),
                      IconTextButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        text: widget.isLast
                            ? "💜️ Bravoo? Tell the world "
                            : "Continue to the next mission",
                      ),
                      SizedBox(height: 12.h),
                      IconTextButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        text: "Back to missions",
                        color: AppColors.primary,
                        textColor: AppColors.white,
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
}
