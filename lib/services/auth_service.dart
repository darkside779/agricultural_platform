import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:agricultural_platform/models/user.dart' as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final google_sign_in.GoogleSignIn _googleSignIn;
  final cloud_firestore.FirebaseFirestore _firestore;

  AuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    google_sign_in.GoogleSignIn? googleSignIn,
    cloud_firestore.FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            google_sign_in.GoogleSignIn(
              scopes: ['email', 'profile'],
              // ClientID for web is handled by the meta tag in web/index.html
            ),
        _firestore = firestore ?? cloud_firestore.FirebaseFirestore.instance;

  Stream<app_user.User> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return app_user.User.empty;
      }
      return await _getUserFromFirestore(firebaseUser.uid, firebaseUser);
    });
  }

  Future<app_user.User> _getUserFromFirestore(String userId, [firebase_auth.User? firebaseUserInstance]) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return app_user.User.fromJson(docSnapshot.data()!);
      } else if (firebaseUserInstance != null) {
        // User authenticated with Firebase but not in Firestore, create them (e.g., after social sign-in)
        final newUser = app_user.User(
          id: firebaseUserInstance.uid,
          email: firebaseUserInstance.email ?? '',
          name: firebaseUserInstance.displayName ?? 'New User',
          role: app_user.UserRole.buyer, // Default role for new social sign-in
          profileImageUrl: firebaseUserInstance.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
        return newUser;
      }
      return app_user.User.empty; // Should ideally not happen if firebaseUserInstance is null and doc doesn't exist
    } catch (e) {
      debugPrint('Error getting user from Firestore: $e');
      throw Exception('Failed to get user data.');
    }
  }


  Future<app_user.User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required app_user.UserRole role,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Sign up failed: No user created.');
      }
      await credential.user!.updateDisplayName(name);
      // await credential.user!.updatePhotoURL(null); // if you have a default

      final newUser = app_user.User(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException on sign up: ${e.message}');
      throw Exception('Sign up failed: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Error on sign up: $e');
      throw Exception('An unknown error occurred during sign up.');
    }
  }

  Future<app_user.User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Sign in failed: User not found.');
      }
      return await _getUserFromFirestore(credential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException on sign in: ${e.message}');
      throw Exception('Sign in failed: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Error on sign in: $e');
      throw Exception('An unknown error occurred during sign in.');
    }
  }

  Future<app_user.User> signInWithGoogle() async {
    firebase_auth.UserCredential? userCredential;
    try {
      if (kIsWeb) {
        final firebase_auth.GoogleAuthProvider googleProvider =
        firebase_auth.GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final google_sign_in.GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

        if (googleUser == null) {
          throw Exception('Google Sign-In cancelled by user.');
        }

        final google_sign_in.GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        if (googleAuth.accessToken == null) {
          throw Exception('Google Sign-In failed: Missing access token.');
        }
        if (googleAuth.idToken == null) {
          throw Exception('Google Sign-In failed: Missing ID token.');
        }

        final firebase_auth.AuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken!,
          idToken: googleAuth.idToken!,
        );
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      if (userCredential?.user == null) {
        throw Exception('Google Sign-In failed: No user credential received.');
      }
      // _getUserFromFirestore will create the user if it's their first time via social
      return await _getUserFromFirestore(userCredential!.user!.uid, userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException on Google sign in: ${e.message}');
      throw Exception('Google Sign-In failed: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Error on Google sign in: $e');
      // Rethrow specific exceptions if needed, or a generic one
      if (e is Exception && e.toString().contains('cancelled')) {
        throw Exception('Google Sign-In cancelled by user.');
      }
      throw Exception('An unknown error occurred during Google Sign-In.');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      // Optionally rethrow or handle, but usually sign out should succeed locally
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException on password reset: ${e.message}');
      throw Exception('Password reset failed: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Error on password reset: $e');
      throw Exception('An unknown error occurred while sending password reset email.');
    }
  }

  Future<app_user.User?> getCurrentFirebaseUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return await _getUserFromFirestore(firebaseUser.uid);
    }
    return null;
  }

  Future<void> updateUserProfile(String userId, {
    String? name,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': cloud_firestore.FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (location != null) updateData['location'] = location;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      // You might also want to update the Firebase Auth user profile if relevant (name, photoURL)
      // if (name != null || profileImageUrl != null) {
      //   await _firebaseAuth.currentUser?.updateDisplayName(name);
      //   await _firebaseAuth.currentUser?.updatePhotoURL(profileImageUrl);
      // }

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Profile update failed.');
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      } else {
        throw Exception('No user currently signed in to delete.');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException on deleting account: ${e.message}');
      throw Exception('Account deletion failed: ${e.message ?? e.code}. You may need to sign in again recently.');
    } catch (e) {
      debugPrint('Error deleting account: $e');
      throw Exception('An unknown error occurred during account deletion.');
    }
  }
}
