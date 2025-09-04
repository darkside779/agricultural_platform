import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agricultural_platform/models/user.dart';

class ProfileService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  // Collection reference for users
  CollectionReference<User> get _usersRef =>
      _firestore.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) =>
                User.fromJson(snapshot.data()!..['id'] = snapshot.id),
            toFirestore: (user, _) => user.toJson()..remove('id'),
          );

  /// Fetches a user's profile from Firestore
  Future<User?> getUserProfile(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      return doc.data();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    }
  }

  /// Updates a user's profile in Firestore
  Future<void> updateUserProfile(
    String userId, {
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _usersRef.doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  /// Uploads a profile picture to Firebase Storage and returns the download URL
  Future<String> uploadProfilePicture(File imageFile, String userId) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final ref = _storage.ref().child('profile_pictures/$userId');

      // Upload the file to Firebase Storage
      final uploadTask = await ref.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Failed to upload profile picture: ${e.message}');
    }
  }

  /// Updates the user's profile picture URL in Firestore
  Future<void> updateProfilePictureUrl(String userId, String imageUrl) async {
    try {
      await _usersRef.doc(userId).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile picture URL: ${e.message}');
    }
  }

  /// Deletes a user's profile picture from Storage and updates the profile
  Future<void> deleteProfilePicture(String userId) async {
    try {
      // Delete the file from Storage
      await _storage.ref().child('profile_pictures/$userId').delete();

      // Remove the profile image URL from the user's document
      await _usersRef.doc(userId).update({
        'profileImageUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete profile picture: ${e.message}');
    }
  }

  /// Gets the user's role
  Future<UserRole> getUserRole(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      return doc.data()?.role ?? UserRole.farmer;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get user role: ${e.message}');
    }
  }

  /// Updates the user's role
  Future<void> updateUserRole(String userId, UserRole newRole) async {
    try {
      await _usersRef.doc(userId).update({
        'role': newRole.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to update user role: ${e.message}');
    }
  }

  /// Stream of user profile changes
  Stream<User?> streamUserProfile(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) => doc.data());
  }
}
