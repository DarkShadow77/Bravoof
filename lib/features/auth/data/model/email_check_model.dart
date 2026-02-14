class EmailCheckResult {
  final bool available;
  final bool isRegistered;
  final String? provider;
  final bool hasPassword;
  final String message;

  EmailCheckResult({
    required this.available,
    required this.isRegistered,
    this.provider,
    required this.hasPassword,
    required this.message,
  });

  factory EmailCheckResult.fromJson(Map<String, dynamic> json) {
    return EmailCheckResult(
      available: json['available'] ?? false,
      isRegistered: json['is_registered'] ?? false,
      provider: json['provider']?.toString(),
      hasPassword: json['has_password'] ?? false,
      message: json['message'] ?? '',
    );
  }

  String get providerLabel {
    switch (provider) {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      case 'email':
        return 'Email & Password';
      default:
        return provider ?? 'Unknown';
    }
  }
}
