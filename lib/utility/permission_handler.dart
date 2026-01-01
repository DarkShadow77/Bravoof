import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app/styles/text_styles.dart';
import '../core/constants/app_colors.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  final status = await Permission.notification.status;

  // Already allowed, nothing to do
  if (status.isGranted) return;

  // iOS first-time request
  if (status.isDenied) {
    _showRequestDialog(context);
    return;
  }

  // User has permanently denied
  if (status.isPermanentlyDenied || status.isRestricted) {
    _showSettingsDialog(context);
  }
}

Future<void> requestIOSNotificationPermission() async {
  final status = await Permission.notification.request();

  if (status.isGranted) {
    debugPrint("✅ Notifications granted");
  } else if (status.isDenied) {
    debugPrint("❌ Notifications denied");
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

void _showRequestDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.black,
      title: RichText(
        text: TextSpan(
          text: "Let Bravoo Send You Notifications! 🥺",
          style: TextStyles.bodyBold16(
            dialogContext,
          ).copyWith(color: AppColors.white),
        ),
      ),
      content: RichText(
        text: TextSpan(
          text:
              "Stay updated on new missions, rewards, and earnings. You can change this anytime in Settings.",
          style: TextStyles.normalMedium14(
            dialogContext,
          ).copyWith(color: AppColors.white75),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: RichText(
            text: TextSpan(
              text: "Not now",
              style: TextStyles.normalMedium14(
                dialogContext,
              ).copyWith(color: AppColors.white),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await requestIOSNotificationPermission();
          },
          child: RichText(
            text: TextSpan(
              text: "Allow",
              style: TextStyles.normalMedium14(dialogContext),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.black,
      title: RichText(
        text: TextSpan(
          text: "Notifications Disabled 🫣",
          style: TextStyles.bodyBold16(
            dialogContext,
          ).copyWith(color: AppColors.white),
        ),
      ),
      content: RichText(
        text: TextSpan(
          text: "Notifications are turned off. Enable them from app settings.",
          style: TextStyles.normalMedium14(
            dialogContext,
          ).copyWith(color: AppColors.white75),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: RichText(
            text: TextSpan(
              text: "Cancel",
              style: TextStyles.normalMedium14(
                dialogContext,
              ).copyWith(color: AppColors.white),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            openAppSettings();
          },
          child: RichText(
            text: TextSpan(
              text: "Open Settings",
              style: TextStyles.normalMedium14(dialogContext),
            ),
          ),
        ),
      ],
    ),
  );
}
