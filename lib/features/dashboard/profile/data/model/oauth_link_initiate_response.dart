class OAuthLinkInitiateResponse {
  final bool requiresVerification;
  final String providerEmail;
  final String currentEmail;
  final bool emailsMatch;

  OAuthLinkInitiateResponse({
    required this.requiresVerification,
    required this.providerEmail,
    required this.currentEmail,
    required this.emailsMatch,
  });

  factory OAuthLinkInitiateResponse.fromJson(Map<String, dynamic> json) {
    return OAuthLinkInitiateResponse(
      requiresVerification: json['requires_verification'] ?? false,
      providerEmail: json['provider_email'] ?? '',
      currentEmail: json['current_email'] ?? '',
      emailsMatch: json['emails_match'] ?? false,
    );
  }
}

class OAuthLinkVerifyResponse {
  final String provider;
  final String providerEmail;

  OAuthLinkVerifyResponse({
    required this.provider,
    required this.providerEmail,
  });

  factory OAuthLinkVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OAuthLinkVerifyResponse(
      provider: json['provider'] ?? '',
      providerEmail: json['provider_email'] ?? '',
    );
  }
}
