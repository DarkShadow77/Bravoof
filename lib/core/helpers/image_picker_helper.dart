import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage({ImageSource? source}) async {
    final image = await _picker.pickImage(
      source: source ?? ImageSource.gallery,
      imageQuality: 25,
    );

    if (image != null) {
      final file = File(image.path);
      final fileSize = await file.length();

      // Convert fileSize to kilobytes or megabytes as needed
      final fileSizeKB = fileSize / 1024; // convert to kilobytes
      final fileSizeMB = fileSizeKB / 1024; // convert to megabytes

      Logger().d('Image size: $fileSize bytes, $fileSizeKB KB, $fileSizeMB MB');
    }

    return image;
  }

  static Future<XFile?> pickVideo(BuildContext context) async {
    final image = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );

    if (image != null) {
      final file = File(image.path);
      final fileSize = await file.length();

      // Convert fileSize to kilobytes or megabytes as needed
      final fileSizeKB = fileSize / 1024; // convert to kilobytes
      final fileSizeMB = fileSizeKB / 1024; // convert to megabytes

      Logger().d('Image size: $fileSize bytes, $fileSizeKB KB, $fileSizeMB MB');
    }

    return image;
  }

  static Future<List<XFile?>> pickImages({int? limit}) async {
    final images = await _picker.pickMultiImage(limit: limit, imageQuality: 40);
    if (limit != null && images.length > limit) {
      return images.take(limit).toList();
    }
    return images;
  }
}

/*Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);
  final file = File(
    '${(await getTemporaryDirectory()).path}/${ObjectId()}.png',
  );
  await file.writeAsBytes(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );
  return file;
}*/
