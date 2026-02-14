class ReferralResult {
  final String referrerUserId;
  final String referrerName;
  final String referrerEmail;
  final String referralCode;

  ReferralResult({
    required this.referrerUserId,
    required this.referrerName,
    required this.referrerEmail,
    required this.referralCode,
  });

  factory ReferralResult.fromJson(Map<String, dynamic> json) {
    return ReferralResult(
      referrerUserId: json['referrer_user_id'] ?? '',
      referrerName: json['referrer_name'] ?? '',
      referrerEmail: json['referrer_email'] ?? '',
      referralCode: json['referral_code'] ?? '',
    );
  }
}
