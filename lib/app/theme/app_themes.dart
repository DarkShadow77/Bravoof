import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';

class AppTheme {
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.white,
  );
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: AppFonts.manrope,
  colorScheme: AppTheme.lightScheme,
  useMaterial3: true,
);
