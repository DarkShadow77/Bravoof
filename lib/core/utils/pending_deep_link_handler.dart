class PendingDeepLink {
  static final PendingDeepLink _instance = PendingDeepLink._();
  static PendingDeepLink get instance => _instance;
  PendingDeepLink._();

  Uri? _pendingUri;

  void save(Uri uri) {
    _pendingUri = uri;
  }

  Uri? consume() {
    final uri = _pendingUri;
    _pendingUri = null; // clear after consuming so it only fires once
    return uri;
  }

  bool get hasPending => _pendingUri != null;
}
