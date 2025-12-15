import 'package:get/get.dart';

import 'app_colors.dart';

class UtilsSnackBars {
  void errorSnackBar({
    String? title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title ?? "Error",
      message,
      backgroundColor: AppColors.error50,
      colorText: AppColors.white,
      snackPosition: position,
    );
  }

  void successSnackBar({
    String? title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title ?? "Success",
      message,
      backgroundColor: AppColors.primary50,
      colorText: AppColors.white,
      snackPosition: position,
    );
  }
}
