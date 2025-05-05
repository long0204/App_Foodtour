// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import '../../../config/constants/strings.dart';
// import '../../../core/export.dart';
// import '../extensions/obj_extension.dart';
// import '../extensions/string_extension.dart';

// class TokenService {
//   TokenService(
//     ApiClient dio,
//   ) : _dio = dio;

//   final ApiClient _dio;
//   final _id = 1;
//   late final Box<bool> _box;

//   Future openBox() async =>
//       _box = await Hive.openBox<bool>(LocalKey.kAuthSkipStatus);

//   bool get _isOpen => Hive.isBoxOpen(LocalKey.kAuthSkipStatus);

//   Future<bool> getStatus() async {
//     if (!_isOpen) await openBox();
//     final data = _box.get(_id);
//     return data ?? true;
//   }

//   Future<bool> saveStatus(bool data) async {
//     if (!_isOpen) await openBox();

//     await _box.put(_id, data);
//     return true;
//   }

//   final _storage = const FlutterSecureStorage(
//       aOptions: AndroidOptions(
//     encryptedSharedPreferences: true,
//   ));

// // Read value
//   Future<String?> getToken() async {
//     final String? value = await _storage.read(key: LocalKey.kAccessToken);
//     return value;
//   }

//   Future<bool> delToken() async {
//     await _storage.delete(key: LocalKey.kAccessToken);
//     final String? value = await _storage.read(key: LocalKey.kAccessToken);
//     return value == null;
//   }

//   Future saveToken(String token) async {
//     try {
//       await _storage.write(key: LocalKey.kAccessToken, value: token);
//     } catch (e) {
//       e.logE('saveToken');
//     }
//   }

//   Future<void> setAndSaveToken(String? accessToken) async {
//     if (accessToken.emptyOrNull()) return;
//     _dio.setToken(accessToken!);
//     await saveToken(accessToken);
//   }
// }
