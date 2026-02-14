import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<String> assetToFile(String assetPath) async {
  final ByteData byteData = await rootBundle.load(assetPath);

  final Directory tempDir = await getTemporaryDirectory();

  final String fileName = assetPath.split('/').last;
  final File file = File('${tempDir.path}/$fileName');

  await file.writeAsBytes(
    byteData.buffer.asUint8List(),
    flush: true,
  );

  return file.path;
}
