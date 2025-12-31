class StreakResponse {
  final int? id;
  final String userId;
  final int currentStreak;
  final DateTime? lastClaimedDate;
  final List<DateTime> history;

  StreakResponse({
    this.id,
    required this.userId,
    required this.currentStreak,
    this.lastClaimedDate,
    required this.history,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '',
      currentStreak: json['current_streak'] ?? 0,
      lastClaimedDate: json['last_claimed_date'] != null
          ? DateTime.parse(json['last_claimed_date'])
          : null,

      history: json['history'] ?? [],
    );
  }

  factory StreakResponse.empty({String userId = ''}) {
    return StreakResponse(
      id: null,
      userId: userId,
      currentStreak: 0,
      lastClaimedDate: null,
      history: const [],
    );
  }

  /// 🔹 Has the user already checked in today (local time)?
  bool get hasCheckedInToday {
    if (lastClaimedDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final last = DateTime(
      lastClaimedDate!.year,
      lastClaimedDate!.month,
      lastClaimedDate!.day,
    );

    return last == today;
  }

  /// 🔹 Next available check-in time (12am local)
  DateTime? get nextCheckInAt {
    if (lastClaimedDate == null) return null;

    final last = DateTime(
      lastClaimedDate!.year,
      lastClaimedDate!.month,
      lastClaimedDate!.day,
    );

    return last.add(const Duration(days: 1));
  }
}
