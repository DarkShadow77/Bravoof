import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  final status = await Permission.notification.status;

  if (status.isGranted) return;

  if (status.isDenied) {
    _showRequestDialog(context);
  }

  if (status.isPermanentlyDenied) {
    _showSettingsDialog(context);
  }
}

void _showRequestDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Let Bravoo Send You Notifications"),
      content: const Text(
        "Stay updated on new missions, rewards, and earnings. You can change this anytime in Settings.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Not now"),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await Permission.notification.request();
          },
          child: const Text("Allow"),
        ),
      ],
    ),
  );
}

void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Notifications Disabled"),
      content: const Text(
        "Notifications are turned off. Enable them from app settings.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
