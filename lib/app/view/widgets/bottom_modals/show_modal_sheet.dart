import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ShowModalSheet extends StatelessWidget {
  const ShowModalSheet({
    super.key,
    required this.child,
    this.minHeight = 20,
    this.maxHeight = 700,
    this.color,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? AppColors.white;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(color: AppColors.black50),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight.h,
              minHeight: minHeight.h,
            ),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
