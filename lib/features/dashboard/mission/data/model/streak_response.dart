class StreakResponse {
  final int? id;
  final String userId;
  final int currentStreak;
  final DateTime? lastClaimedDate;
  final List<DateTime> history;
  final int? coinsAwarded;
  final bool? isMilestone;
  final String? message;

  StreakResponse({
    this.id,
    required this.userId,
    required this.currentStreak,
    this.lastClaimedDate,
    required this.history,
    this.coinsAwarded,
    this.isMilestone,
    this.message,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      currentStreak: json['currentStreak'] ?? 0,
      lastClaimedDate: json['lastClaimedDate'] != null
          ? DateTime.parse(json['lastClaimedDate'])
          : null,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e.toString()))
              .toList() ??
          [],
      coinsAwarded: json['coinsAwarded'] ?? 0,
      isMilestone: json['isMilestone'] ?? false,
      message: json['message'] ?? "",
    );
  }

  factory StreakResponse.empty({String userId = ''}) {
    return StreakResponse(
      id: null,
      userId: userId,
      currentStreak: 0,
      lastClaimedDate: null,
      history: const [],
      coinsAwarded: 0,
      isMilestone: false,
      message: "",
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
