class PendingReferralCode {
  static final PendingReferralCode _instance = PendingReferralCode._();
  static PendingReferralCode get instance => _instance;
  PendingReferralCode._();

  String? _code;

  void save(String code) => _code = code;

  String? consume() {
    final code = _code;
    _code = null;
    return code;
  }

  bool get hasPending => _code != null;
}
