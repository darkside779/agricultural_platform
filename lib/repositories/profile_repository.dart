// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:agricultural_platform/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  /// Fetches the user profile from the database
  Future<User> getUserProfile(String userId);

  /// Stream of user profile changes
  Stream<User> streamUserProfile(String userId);

  /// Updates the user profile in the database
  Future<void> updateUserProfile(
    String userId, {
    required Map<String, dynamic> updates,
  });

  /// Uploads a profile picture and returns the download URL
  Future<String> uploadProfilePicture({
    required XFile imageFile,
    required void Function(double) onProgress,
  });

  /// Deletes the user's profile picture
  Future<void> deleteProfilePicture(String userId);

  /// Gets the user's role
  Future<UserRole> getUserRole(String userId);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return User.fromMap(doc.data()!..['id'] = doc.id);
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      rethrow;
    }
  }

  @override
  Stream<User> streamUserProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => User.fromMap(doc.data()!..['id'] = doc.id));
  }

  @override
  Future<void> updateUserProfile(
    String userId, {
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadProfilePicture({
    required XFile imageFile,
    required void Function(double) onProgress,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      final uploadTask = ref.putFile(
        File(imageFile.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Listen for progress
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        final progress =
            taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
        onProgress(progress);
      });

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProfilePicture(String userId) async {
    try {
      // Delete the file from storage
      await _storage.ref('profile_pictures/$userId.jpg').delete();

      // Remove the profile image URL from user document
      await updateUserProfile(
        userId,
        updates: {'profileImageUrl': null},
      );
    } catch (e) {
      debugPrint('Error deleting profile picture: $e');
      rethrow;
    }
  }

  @override
  Future<UserRole> getUserRole(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return UserRole.user; // Default role
      }
      return UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${doc.get('role')}',
        orElse: () => UserRole.user,
      );
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return UserRole.user; // Default role on error
    }
  }
}
