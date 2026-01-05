import 'package:intl/intl.dart';

String formatAmount(num value, {bool compact = true, String locale = 'en_US'}) {
  if (!compact || value < 1000000) {
    return NumberFormat("#,##0", locale).format(value);
  }

  final compactFormat = NumberFormat.compact(locale: locale);

  return compactFormat.format(value);
}
