import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    _showNotificationDialog(context);
  }
}

void _showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Let Bravoo Send You Notifications"),
        content: Text(
          "Stay updated on new missions, rewards, and earnings. You can change this anytime in Settings.",
        ),
        actions: [
          TextButton(
            child: Text("Don't Allow"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: Text("Ok"),
            onPressed: () async {
              Navigator.pop(context);
              final result = await Permission.notification.request();

              if (result.isPermanentlyDenied) {
                openAppSettings();
              }
            },
          ),
        ],
      );
    },
  );
}
