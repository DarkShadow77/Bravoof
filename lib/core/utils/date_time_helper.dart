import 'package:intl/intl.dart';

String formatSmartDate(String isoDate, {String locale = 'en_US'}) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final dateDay = DateTime(date.year, date.month, date.day);

  final difference = today.difference(dateDay).inDays;
  final time = DateFormat('h:mm a', locale).format(date);

  // Today
  if (difference == 0) {
    return 'Today, $time';
  }

  // Yesterday
  if (difference == 1) {
    return 'Yesterday, $time';
  }

  // Same calendar week
  if (_isSameWeek(date, now)) {
    final dayName = DateFormat('EEE', locale).format(date);
    return '$dayName, $time';
  }

  // Same year
  if (date.year == now.year) {
    return '${DateFormat('d MMM', locale).format(date)}, $time';
  }

  // Different year
  return '${DateFormat('d MMM yyyy', locale).format(date)}, $time';
}

bool _isSameWeek(DateTime a, DateTime b) {
  final startOfWeekA = _startOfWeek(a);
  final startOfWeekB = _startOfWeek(b);
  return startOfWeekA == startOfWeekB;
}

DateTime _startOfWeek(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}
