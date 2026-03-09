import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> assetToFile(String assetPath) async {
  try {
    // Load the asset
    final ByteData byteData = await rootBundle.load(assetPath);

    // Get the directory (with timeout for iOS issues)
    final Directory dir = await getApplicationDocumentsDirectory().timeout(
      const Duration(seconds: 10), // Increased timeout
      onTimeout: () {
        throw Exception('Directory access timed out');
      },
    );

    // Create a unique filename to avoid conflicts
    final String fileName = path.basename(assetPath);
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final File file = File('${dir.path}/${timestamp}_$fileName');

    // Write the file with error handling
    await file
        .writeAsBytes(byteData.buffer.asUint8List(), flush: true)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('File write timed out');
          },
        );

    // Verify the file was created
    if (!await file.exists()) {
      throw Exception('File was not created successfully');
    }

    return file.path;
  } catch (e) {
    print('Error in assetToFile: $e');
    rethrow; // Re-throw to be caught by the caller
  }
}
