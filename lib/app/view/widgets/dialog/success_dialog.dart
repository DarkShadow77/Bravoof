import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/fonts.dart';
import '../button/icon_text_button.dart';

Future<dynamic> successDialog({
  required String title,
  required String subTitle,
  required String mainBtnText,
  String? subBtnText,
  Widget? subBtnIcon,
  required VoidCallback mainBtnPressed,
  VoidCallback? subBtnPressed,
}) async {
  return Get.dialog(
    name: "success_dialog",
    barrierColor: Colors.transparent,

    barrierDismissible: true,
    SuccessDialog(
      title: title,
      subTitle: subTitle,
      mainBtnText: mainBtnText,
      subBtnText: subBtnText,
      subBtnIcon: subBtnIcon,
      mainBtnPressed: mainBtnPressed,
      subBtnPressed: subBtnPressed,
    ),
  );
}

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.mainBtnText,
    this.subBtnText,
    this.subBtnIcon,
    required this.mainBtnPressed,
    this.subBtnPressed,
  });

  final String title;
  final String subTitle;
  final String mainBtnText;
  final String? subBtnText;
  final Widget? subBtnIcon;
  final VoidCallback mainBtnPressed;
  final VoidCallback? subBtnPressed;

  @override
  State<SuccessDialog> createState() => _AskingDialogState();
}

class _AskingDialogState extends State<SuccessDialog> with UIToolMixin {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });

    super.initState();
  }

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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15.h),
                    RichText(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: widget.title,
                        style: TextStyles.bigTitleBold24(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Image.asset(
                      AssetsPngImages.coinBox,
                      width: 115.w,
                      height: 115.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.subTitle,
                        style: TextStyles.bodySemiBold16(
                          context,
                        ).copyWith(color: AppColors.grey550),
                      ),
                    ),
                    SizedBox(height: 27.h),
                    if (widget.subBtnText != null) ...[
                      IconTextButton(
                        height: 56,
                        onPressed: widget.subBtnPressed ?? () {},
                        text: widget.subBtnText ?? "",
                        iconWidget: widget.subBtnIcon,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    IconTextButton(
                      height: 56,
                      onPressed: widget.mainBtnPressed,
                      text: widget.mainBtnText,
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
    );
  }
}
