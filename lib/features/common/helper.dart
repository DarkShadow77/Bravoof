
import 'package:path/path.dart' as p;

String shortenFileName(String fileName, {int maxLength = 10}) {
  String ext = p.extension(fileName);     // ".jpg"
  String name = p.basenameWithoutExtension(fileName); // "photo12345"

  if (name.length <= maxLength) return fileName;
print(ext);
  return '${name.substring(0, maxLength)}$ext';
}

