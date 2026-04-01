// lib/services/auth_service.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/api/api_client.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateRandomKey(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

  Future<void> _saveToken(String uid) async {
    var box = await Hive.openBox('userBox');
    await box.put('token', uid);
  }

  Future<void> _saveUserToFirestore(User user, {String? password, String? fullname}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'userId': user.uid,
        'username': user.email,
        'fullname': fullname ?? user.displayName,
        'avatar': user.photoURL,
        'created_at': DateTime.now().toIso8601String(),
        'key': _generateRandomKey(20),
        'password': password ?? '',
      });
    }
    await _saveToken(user.uid);

    await _syncUserToBackend(user, fullname: fullname);
  }

  Future<void> _syncUserToBackend(User user, {String? fullname, String? avatarUrl}) async {
    try {
      await apiClient.post(
        '/users/sync',
        data: {
          "id": user.uid,
          "fullname": fullname ?? user.displayName ?? "Người dùng",
          "username": user.email,
          "avatar_url": avatarUrl ?? user.photoURL ?? "",
        },
      );
    } catch (e) {
      print("Lỗi đồng bộ Backend: $e");
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

  // 3. Đăng nhập Google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final cred = await _auth.signInWithCredential(GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,
    ));
    if (cred.user != null) {
      await _saveUserToFirestore(cred.user!);
    }
    return cred;
  }

  Future<UserCredential?> signInWithApple() async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final cred = await _auth.signInWithCredential(OAuthProvider('apple.com').credential(
      idToken: appleIdCredential.identityToken, accessToken: appleIdCredential.authorizationCode,
    ));
    if (cred.user != null) {
      await _saveUserToFirestore(cred.user!, fullname: "${appleIdCredential.givenName} ${appleIdCredential.familyName}");
    }
    return cred;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    var box = await Hive.openBox('userBox');
    await box.delete('token');
    await box.clear();
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