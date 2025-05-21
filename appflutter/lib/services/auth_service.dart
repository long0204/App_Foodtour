import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';

import '../ui/auth/provider/auth_notifier.dart';

class AuthService {
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  late Box _box;

  String? getUsername() => _box.get('username');


  AuthService._();

  Future<void> init() async {
    _box = Hive.box('userBox');
  }

  Future<void> login(String username, String password) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Tài khoản hoặc mật khẩu sai");
    }

    final userDoc = query.docs.first;
    final key = userDoc['key'];
    await _box.put('token', key);
    await _box.put('username', username);
    authNotifier.login();
  }

  Future<void> register({
    required String username,
    required String password,
    required String key,
  }) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (query.docs.isNotEmpty) {
      throw Exception("Email đã được sử dụng");
    }

    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'password': password,
      'key': key,
      'created_at': DateTime.now().toIso8601String(),
      'avatar': null,
      'birth_date': null,
      'fullname': null,
    });

    await _box.put('token', key);
  }

  Future<String> uploadAvatar(File file, String key) async {
    final ref = FirebaseStorage.instance.ref().child('avatars/$key.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> updateProfile({
    required String key,
    String? avatar,
    DateTime? birthDate,
  }) async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('key', isEqualTo: key)
        .get();

    if (users.docs.isNotEmpty) {
      final doc = users.docs.first;
      await doc.reference.update({
        if (avatar != null) 'avatar': avatar,
        if (birthDate != null) 'birth_date': birthDate.toIso8601String(),
      });
    }
  }



  bool isLoggedIn() => _box.get('token') != null;

  Future<void> logout() async {
    await _box.delete('token');
    await _box.delete('username');
  }

  String? getToken() => _box.get('token');
}

final authService = AuthService.instance;
