import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/version_model.dart';
import 'api_service.dart';

class VersionCheckService {
  VersionCheckService();

  Future<VersionCheckResult> checkVersion() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final platform = Platform.isAndroid ? 'android' : 'ios';

      // Call edge function
      final result = await ApiService.instance!
          .invokeEdgeFunction<VersionCheckResult>(
            functionName: 'check-app-version',
            requiresAuth: false,
            body: {'platform': platform, 'currentVersion': currentVersion},
            onSuccess: (data) => VersionCheckResult.fromJson(data),
            fallbackErrorMessage: 'Failed to check app version',
          );

      return result.fold((error) {
        // Fail open — if check fails, allow app to run
        return const VersionCheckResult(
          status: VersionStatus.ok,
          updateRequired: false,
          updateAvailable: false,
          isBlocked: false,
          inMaintenance: false,
        );
      }, (versionCheck) => versionCheck);
    } catch (e) {
      // Fail open
      return const VersionCheckResult(
        status: VersionStatus.ok,
        updateRequired: false,
        updateAvailable: false,
        isBlocked: false,
        inMaintenance: false,
      );
    }
  }

  Future<void> openStore(String? storeUrl) async {
    if (storeUrl == null) return;

    final uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Android In-App Update
  Future<void> checkAndPerformInAppUpdate() async {
    if (!Platform.isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Immediate update for force updates
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }
        // Flexible update for optional updates
        else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          // Listen for download completion
          InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      print('In-app update error: $e');
    }
  }
}
