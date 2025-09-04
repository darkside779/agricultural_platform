import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage
  ///
  /// [file] - The file to upload
  /// [userId] - The ID of the user who owns the file
  /// [fileType] - The type of file (e.g., 'profile_pictures', 'documents')
  /// [onProgress] - Callback that receives upload progress (0.0 to 1.0)
  ///
  /// Returns the download URL of the uploaded file
  Future<String> uploadFile({
    required File file,
    required String userId,
    required String fileType,
    void Function(double)? onProgress,
  }) async {
    try {
      // Create a reference to the file in Firebase Storage
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
      final ref = _storage.ref().child('users/$userId/$fileType/$fileName');

      // Create file metadata including content type
      final metadata = SettableMetadata(
        contentType: _getMimeType(file.path),
        customMetadata: {
          'uploaded_by': userId,
          'uploaded_at': DateTime.now().toIso8601String(),
        },
      );

      // Start the upload task
      final uploadTask = ref.putFile(file, metadata);

      // Listen for state changes and progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for the upload to complete
      final taskSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Deletes a file from Firebase Storage
  ///
  /// [fileUrl] - The download URL of the file to delete
  Future<void> deleteFile(String fileUrl) async {
    try {
      // Extract the reference from the URL
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        throw Exception('Failed to delete file: ${e.message}');
      }
      // If the file doesn't exist, we can consider it deleted
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Gets a reference to a file in Firebase Storage
  ///
  /// [path] - The path to the file in Firebase Storage
  Reference getFileReference(String path) {
    return _storage.ref().child(path);
  }

  // Helper method to determine MIME type from file extension
  String? _getMimeType(String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream';
    }
  }
}
