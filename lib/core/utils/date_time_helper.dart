import 'package:intl/intl.dart';

String formatSmartDate(
  String isoDate, {
  String locale = 'en_US',
  bool showTime = true,
}) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final dateDay = DateTime(date.year, date.month, date.day);

  final difference = today.difference(dateDay).inDays;
  final time = DateFormat('h:mm a', locale).format(date);

  // Today
  if (difference == 0) {
    if (!showTime) return 'Today';
    return 'Today, $time';
  }

  // Yesterday
  if (difference == 1) {
    if (!showTime) return 'Yesterday';
    return 'Yesterday, $time';
  }

  // Same calendar week
  if (_isSameWeek(date, now)) {
    final dayName = DateFormat('EEE', locale).format(date);
    if (!showTime) return dayName;
    return '$dayName, $time';
  }

  // Same year
  if (date.year == now.year) {
    if (!showTime) return DateFormat('d MMM', locale).format(date);
    return '${DateFormat('d MMM', locale).format(date)}, $time';
  }

  // Different year
  if (!showTime) return DateFormat('d MMM yyyy', locale).format(date);
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

String formatSMHDTime(String rawDate) {
  try {
    // Parse the ISO 8601 formatted date string
    final date = DateTime.parse(rawDate).toLocal();

    // Get the current time
    final now = DateTime.now();

    // Calculate the time difference
    final diff = now.difference(date);

    // Return the formatted time based on the difference
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays <= 3) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('dd MMM yy').format(date); // e.g. 05 Nov 25
    }
  } catch (e) {
    return 'Invalid date';
  }
}
