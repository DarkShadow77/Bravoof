import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

Future<dynamic> outerLoadingDialog({
  required String text,
  bool canPop = true,
  VoidCallback? onPop,
}) async {
  return Get.dialog(
    name: "outer_loading_dialog",
    barrierDismissible: canPop,
    barrierColor: AppColors.black29,
    transitionDuration: const Duration(milliseconds: 800),
    OuterLoadingDialog(text: text, canPop: canPop, onPop: onPop),
  );
}

class OuterLoadingDialog extends StatefulWidget {
  const OuterLoadingDialog({
    super.key,
    required this.text,
    required this.canPop,
    this.onPop,
  });

  final String text;
  final bool canPop;
  final VoidCallback? onPop;

  @override
  State<OuterLoadingDialog> createState() => _OuterLoadingDialogState();
}

class _OuterLoadingDialogState extends State<OuterLoadingDialog> {
  bool delay = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        delay = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      onPopInvokedWithResult: (canPop, result) {
        if (!canPop) widget.onPop;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingAnimationWidget.fallingDot(
            color: AppColors.primary,
            size: 65.sp,
          ),
          SizedBox(height: 8.h),
          Opacity(
            opacity: delay ? 1 : 0,
            child: RichText(
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: widget.text,
                style: TextStyles.normalMedium14(
                  context,
                ).copyWith(color: AppColors.white75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
