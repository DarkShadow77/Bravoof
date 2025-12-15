import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';

class FontSizes {
  static final smallCard = 8.0.sp;
  static final card = 10.0.sp;
  static final small = 12.0.sp;
  static final normal = 14.0.sp;
  static final body = 16.0.sp;
  static final title = 20.0.sp;
  static final bigTitle = 24.0.sp;
  static final heading2 = 32.0.sp;
  static final heading1 = 38.0.sp;
}

class TextStyles {
  static TextStyle smallCardRegular8(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.smallCard,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallCardMedium8(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.smallCard,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallCardSemibold8(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.smallCard,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallCardBold8(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.smallCard,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle cardLight10(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: FontSizes.card,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle cardRegular10(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.card,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle cardMedium10(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.card,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle cardSemibold10(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.card,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle cardBold10(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.card,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallRegular12(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.small,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallMedium12(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.small,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallSemibold12(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.small,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle smallBold12(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.small,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle normalRegular14(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.normal,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle normalMedium14(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.normal,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle normalSemibold14(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.normal,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle normalBold14(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.normal,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bodyRegular16(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.body,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bodyMedium16(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.body,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bodySemiBold16(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.body,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bodyBold16(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.body,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle titleRegular20(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.title,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle titleMedium20(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.title,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle titleSemiBold20(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.title,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle titleBold20(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.title,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bigTitleRegular24(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.bigTitle,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bigTitleMedium24(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.bigTitle,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bigTitleSemiBold24(
    BuildContext context, {
    double opacity = 1,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.bigTitle,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle bigTitleBold24(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.bigTitle,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h2Regular32(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.heading2,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h2Medium32(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.heading2,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h2SemiBold32(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.heading2,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h2Bold32(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.heading2,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h2ExtraBold32(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: FontSizes.heading2,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h1Regular38(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.heading1,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h1Medium38(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.heading1,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h1SemiBold38(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.heading1,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }

  static TextStyle h1Bold38(BuildContext context, {double opacity = 1}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.heading1,
      fontFamily: AppFonts.manrope,
      color: AppColors.dark.withValues(alpha: opacity),
    );
  }
}
