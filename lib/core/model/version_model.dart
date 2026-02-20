enum VersionStatus { ok, updateAvailable, forceUpdate, blocked, maintenance }

class VersionCheckResult {
  final VersionStatus status;
  final bool updateRequired;
  final bool updateAvailable;
  final bool isBlocked;
  final bool inMaintenance;
  final String? latestVersion;
  final String? minSupportedVersion;
  final String? title;
  final String? message;
  final String? storeUrl;

  const VersionCheckResult({
    required this.status,
    required this.updateRequired,
    required this.updateAvailable,
    required this.isBlocked,
    required this.inMaintenance,
    this.latestVersion,
    this.minSupportedVersion,
    this.title,
    this.message,
    this.storeUrl,
  });

  factory VersionCheckResult.fromJson(Map<String, dynamic> json) {
    return VersionCheckResult(
      status: _parseStatus(json['status']),
      updateRequired: json['updateRequired'] ?? false,
      updateAvailable: json['updateAvailable'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      inMaintenance: json['inMaintenance'] ?? false,
      latestVersion: json['latestVersion'],
      minSupportedVersion: json['minSupportedVersion'],
      title: json['title'],
      message: json['message'],
      storeUrl: json['storeUrl'],
    );
  }

  static VersionStatus _parseStatus(String? status) {
    switch (status) {
      case 'update_available':
        return VersionStatus.updateAvailable;
      case 'force_update':
        return VersionStatus.forceUpdate;
      case 'blocked':
        return VersionStatus.blocked;
      case 'maintenance':
        return VersionStatus.maintenance;
      default:
        return VersionStatus.ok;
    }
  }
}
