// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  static Future<File?> pickImage({
    required BuildContext context,
    bool fromCamera = false,
    bool cropImage = true,
    int maxWidth = 1024,
    int quality = 80,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: quality,
        maxWidth: maxWidth.toDouble(),
      );

      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);

      // Crop the image if needed
      if (cropImage) {
        final croppedFile = await _cropImage(imageFile);
        if (croppedFile != null) {
          imageFile = croppedFile;
        }
      }

      // Compress the image
      final compressedFile = await _compressImage(imageFile);
      return compressedFile;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Crop the selected image
  static Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

  /// Compress the image to reduce file size
  static Future<File> _compressImage(File file) async {
    try {
      // Read the image file
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return file;

      // Compress the image
      final compressed = img.copyResize(
        image,
        width: 800, // Max width
        height: 800, // Max height
        maintainAspect: true,
      );

      // Get temporary directory
      final dir = await getTemporaryDirectory();
      final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${dir.path}/$filename';

      // Save compressed image
      final compressedFile = File(filePath);
      await compressedFile.writeAsBytes(img.encodeJpg(compressed, quality: 80));

      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return file; // Return original if compression fails
    }
  }

  /// Convert Uint8List to File
  static Future<File> uint8ListToFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Get image size in KB or MB
  static String getImageSize(File file) {
    final sizeInBytes = file.lengthSync();
    if (sizeInBytes < 1024) {
      return '${sizeInBytes}B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }
}
