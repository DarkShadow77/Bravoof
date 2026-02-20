import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

String formatAmount(
  num value, {
  bool compact = true,
  bool uniComp = false,
  String locale = 'en_US',
}) {
  if (!uniComp) {
    if (!compact || value < 1000000) {
      return NumberFormat("#,##0", locale).format(value);
    }

    final compactFormat = NumberFormat.compact(locale: locale);

    return compactFormat.format(value);
  } else {
    if (!compact) {
      return NumberFormat("#,##0", locale).format(value);
    }

    if (value < 1000) {
      return NumberFormat("#,##0", locale).format(value);
    }

    if (value < 1000000) {
      final v = value / 1000;
      return "${_trim(v)}k";
    }

    if (value < 1000000000) {
      final v = value / 1000000;
      return "${_trim(v)}M";
    }

    final v = value / 1000000000;
    return "${_trim(v)}B";
  }
}

String _trim(num value) {
  final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  return formatted;
}

String shortenFileName(String fileName, {int maxLength = 10}) {
  String ext = p.extension(fileName); // ".jpg"
  String name = p.basenameWithoutExtension(fileName); // "photo12345"

  if (name.length <= maxLength) return fileName;
  print(ext);
  return '${name.substring(0, maxLength)}$ext';
}
