import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';

Future<dynamic> jackpotSuccessDialog({
  required String rewardType,
  required int rewardValue,
}) async {
  return Get.dialog(
    name: "jackpot_success_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    JackpotSuccessDialog(rewardType: rewardType, rewardValue: rewardValue),
  );
}

class JackpotSuccessDialog extends StatefulWidget {
  const JackpotSuccessDialog({
    super.key,
    required this.rewardType,
    required this.rewardValue,
  });

  final String rewardType;
  final int rewardValue;

  @override
  State<JackpotSuccessDialog> createState() => _AskingDialogState();
}

class _AskingDialogState extends State<JackpotSuccessDialog> with UIToolMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white50,
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Image.asset(
                  widget.rewardType == "gift"
                      ? AssetsPngImages.gift
                      : AssetsPngImages.one50,
                  height: 42.h,
                  width: 42.w,
                ),
                RichText(
                  text: TextSpan(
                    text: "+${widget.rewardValue}",
                    style: TextStyles.bigTitleBold24(
                      context,
                    ).copyWith(fontFamily: AppFonts.baloo2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
