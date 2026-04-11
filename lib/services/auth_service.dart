import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/api/api_client.dart';
import 'secure_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiClient? _apiClient; // Optional API client for backend sync

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient;

  String _generateRandomKey(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

  Future<void> _saveToken(String uid) async {
    try {
      await secureStorage.saveAuthToken(uid);
      await secureStorage.saveUserId(uid);

      var box = await Hive.openBox('userBox');
      await box.put('token', uid);
    } catch (e) {
      print('❌ Error saving token: $e');
      rethrow;
    }
  }

  Future<void> _saveUserToFirestore(User user, {String? password, String? fullname}) async {
    try {
      
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        await userDoc.set({
          'userId': user.uid,
          'username': user.email ?? '',
          'fullname': fullname ?? user.displayName ?? 'Người dùng',
          'avatar': user.photoURL ?? '',
          'created_at': DateTime.now().toIso8601String(),
          'key': _generateRandomKey(20),
          'password': password ?? '',
        });
        print("✅ New user document created");
      } else {
        print("ℹ️ User document already exists");
      }
      
      await _saveToken(user.uid);
      print("✅ Token saved successfully");

      await _syncUserToBackend(user, fullname: fullname);
    } catch (e, stackTrace) {
      print("❌ Error saving user to Firestore: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<void> _syncUserToBackend(User user, {String? fullname, String? avatarUrl}) async {
    // Skip if no API client provided
    if (_apiClient == null) {
      print("ℹ️ Backend sync skipped (no API client)");
      return;
    }
    
    try {
      await _apiClient!.post(
        '/users/sync',
        data: {
          "id": user.uid,
          "fullname": fullname ?? user.displayName ?? "Người dùng",
          "username": user.email,
          "avatar_url": avatarUrl ?? user.photoURL ?? "",
        },
      ).timeout(Duration(seconds: 10));
      
      print("✅ Backend sync successful");
    } catch (e) {
      print("⚠️ Backend sync failed (non-critical): $e");
      // Don't throw - allow user to continue
      // Backend sync is not critical for login
    }
  }

  // 1. Đăng ký Email
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (cred.user != null) {
      await _saveUserToFirestore(cred.user!, password: password);
    }
    return cred;
  }

  // 2. Đăng nhập Email
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (cred.user != null) {
      await _saveToken(cred.user!.uid);
    }
    return cred;
  }

  // 2.1. Gửi email reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to: $email');
    } catch (e) {
      print('❌ Error sending password reset email: $e');
      rethrow;
    }
  }

  // 3. Đăng nhập Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("🔵 Starting Google sign in...");
      
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("❌ Google sign in cancelled by user");
        return null;
      }
      
      print("✅ Google user: ${googleUser.email}");
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final cred = await _auth.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,
      ));
      
      if (cred.user != null) {
        print("✅ Firebase auth successful: ${cred.user!.uid}");
        await _saveUserToFirestore(cred.user!);
        print("✅ User saved to Firestore and token saved");
      }
      
      return cred;
    } catch (e, stackTrace) {
      print("❌ Google sign in error: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  // 4. Đăng nhập Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      print("🍎 Starting Apple sign in...");
      
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      
      print("✅ Apple credential received");
      
      final cred = await _auth.signInWithCredential(OAuthProvider('apple.com').credential(
        idToken: appleIdCredential.identityToken, accessToken: appleIdCredential.authorizationCode,
      ));
      
      if (cred.user != null) {
        print("✅ Firebase auth successful: ${cred.user!.uid}");
        
        final givenName = appleIdCredential.givenName ?? '';
        final familyName = appleIdCredential.familyName ?? '';
        final fullName = '$givenName $familyName'.trim();
        
        await _saveUserToFirestore(cred.user!, fullname: fullName.isEmpty ? null : fullName);
        print("✅ User saved to Firestore and token saved");
      }
      
      return cred;
    } catch (e, stackTrace) {
      print("❌ Apple sign in error: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      await secureStorage.clearAll();
      var box = await Hive.openBox('userBox');
      await box.delete('token');
      await box.clear();
    } catch (e) {
      print('❌ Error during sign out: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({String? fullname, String? avatarUrl}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (fullname != null) updates['fullname'] = fullname;
    if (avatarUrl != null) updates['avatar'] = avatarUrl;

    if (updates.isNotEmpty) {
      // Lưu Firebase
      await _firestore.collection('users').doc(user.uid).update(updates);

      if (fullname != null) await user.updateDisplayName(fullname);
      if (avatarUrl != null) await user.updatePhotoURL(avatarUrl);

      await _syncUserToBackend(user, fullname: fullname, avatarUrl: avatarUrl);
    }
  }

}