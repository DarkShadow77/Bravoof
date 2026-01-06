import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';

class InnerLoading extends StatelessWidget {
  const InnerLoading({
    super.key,
    this.size = 24,
  });

  final double size;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(4.r),
      ),
      child: LoadingAnimationWidget.fallingDot(
        color: AppColors.primary,
        size: size.sp,
      ),
    );
  }
}
