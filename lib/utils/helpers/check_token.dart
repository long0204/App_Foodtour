import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();

  TokenService._internal();
  factory TokenService() => _instance;

  final String _boxName = 'secureBox';
  final String _tokenKey = 'token';
  final List<int> _password = [132];

  final Uint8List encryptionKey = Uint8List.fromList([
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32
  ]);
  Future<void> init() async {
    final key = Hive.generateSecureKey();
    await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<void> saveToken(String token) async {
    var box = Hive.box(_boxName);
    await box.put(_tokenKey, token);
  }

  Future<(bool, String)> getHasToken() async {
    try {
      await init();
      var box = Hive.box(_boxName);
      final token = await box.get(_tokenKey);
      return (token != null && token.isNotEmpty, token! as String);
    } catch (e) {
      return (false, '');
    }
  }

  Future<void> deleteToken() async {
    var box = Hive.box(_boxName);
    await box.delete(_tokenKey);
  }
}

final tokenService = TokenService._internal();
