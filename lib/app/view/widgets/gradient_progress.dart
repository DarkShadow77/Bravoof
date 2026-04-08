import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';

class GradientProgress extends StatelessWidget {
  const GradientProgress({
    super.key,
    required this.height,
    required this.progress,
    this.radius = 100,
    this.color,
    this.backgroundColor,
  });

  final double height;
  final double progress;
  final double radius;
  final List<Color>? color;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final mainColour = color ?? [Color(0xFFA259FF), Color(0xFFDEC4FF)];
    final bgColor = backgroundColor ?? AppColors.grey200;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: Container(
        height: height.h,
        width: double.infinity,
        color: bgColor, // background
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: mainColour,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
