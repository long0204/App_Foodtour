// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart' as hive;
import 'package:logger/logger.dart';

/// Service để quản lý secure storage cho tokens và sensitive data
/// Sử dụng flutter_secure_storage để mã hóa data trên device
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  final _logger = Logger();

  // Storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _rememberEmailKey = 'remember_email';
  static const String _rememberPasswordKey = 'remember_password';
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Lưu auth token (encrypted)
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
      _logger.i('✅ Auth token saved securely');
    } catch (e) {
      _logger.e('❌ Error saving auth token: $e');
      rethrow;
    }
  }

  /// Lấy auth token
  Future<String?> getAuthToken() async {
    try {
      final token = await _secureStorage.read(key: _authTokenKey);
      if (token != null) {
        _logger.i('✅ Auth token retrieved');
      }
      return token;
    } catch (e) {
      _logger.e('❌ Error reading auth token: $e');
      return null;
    }
  }

  /// Lưu refresh token (encrypted)
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
      _logger.i('✅ Refresh token saved securely');
    } catch (e) {
      _logger.e('❌ Error saving refresh token: $e');
      rethrow;
    }
  }

  /// Lấy refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      _logger.e('❌ Error reading refresh token: $e');
      return null;
    }
  }

  /// Lưu user ID
  Future<void> saveUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
      _logger.i('✅ User ID saved securely');
    } catch (e) {
      _logger.e('❌ Error saving user ID: $e');
      rethrow;
    }
  }

  /// Lấy user ID
  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      _logger.e('❌ Error reading user ID: $e');
      return null;
    }
  }

  /// Xóa tất cả secure data (logout)
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      _logger.i('✅ All secure data cleared');
    } catch (e) {
      _logger.e('❌ Error clearing secure data: $e');
      rethrow;
    }
  }

  /// Xóa auth token
  Future<void> deleteAuthToken() async {
    try {
      await _secureStorage.delete(key: _authTokenKey);
      _logger.i('✅ Auth token deleted');
    } catch (e) {
      _logger.e('❌ Error deleting auth token: $e');
      rethrow;
    }
  }

  /// Check xem có token không
  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== Remember Me Feature ====================
  
  /// Lưu email và password cho remember me
  Future<void> saveRememberMe(String email, String password) async {
    try {
      await _secureStorage.write(key: _rememberEmailKey, value: email);
      await _secureStorage.write(key: _rememberPasswordKey, value: password);
      _logger.i('✅ Remember me credentials saved securely');
    } catch (e) {
      _logger.e('❌ Error saving remember me: $e');
      rethrow;
    }
  }
  
  /// Lấy email và password đã lưu
  Future<Map<String, String?>> getRememberMe() async {
    try {
      final email = await _secureStorage.read(key: _rememberEmailKey);
      final password = await _secureStorage.read(key: _rememberPasswordKey);
      return {'email': email, 'password': password};
    } catch (e) {
      _logger.e('❌ Error reading remember me: $e');
      return {'email': null, 'password': null};
    }
  }
  
  /// Xóa remember me credentials
  Future<void> clearRememberMe() async {
    try {
      await _secureStorage.delete(key: _rememberEmailKey);
      await _secureStorage.delete(key: _rememberPasswordKey);
      _logger.i('✅ Remember me credentials cleared');
    } catch (e) {
      _logger.e('❌ Error clearing remember me: $e');
      rethrow;
    }
  }
  
  /// Check xem có remember me không
  Future<bool> hasRememberMe() async {
    final data = await getRememberMe();
    return data['email'] != null && data['email']!.isNotEmpty;
  }

  // ==================== Biometric Authentication ====================
  
  /// Lưu biometric enabled preference
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(
        key: _biometricEnabledKey,
        value: enabled.toString(),
      );
      _logger.i('✅ Biometric preference saved: $enabled');
    } catch (e) {
      _logger.e('❌ Error saving biometric preference: $e');
      rethrow;
    }
  }
  
  /// Lấy biometric enabled preference
  Future<bool> getBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      _logger.e('❌ Error reading biometric preference: $e');
      return false;
    }
  }

  /// Migrate data từ Hive sang SecureStorage (one-time migration)
  Future<void> migrateFromHive() async {
    try {

      final box = await hive.Hive.openBox('userBox');

      final oldToken = box.get('token');
      
      if (oldToken != null && oldToken is String) {
        // Save vào secure storage
        await saveAuthToken(oldToken);
        await saveUserId(oldToken);

        // Xóa old token khỏi Hive
        await box.delete('token');

        _logger.i('✅ Successfully migrated token from Hive to SecureStorage');
      } else {
        _logger.i('ℹ️ No token found in Hive to migrate');
      }
      
      await box.close();
      
      _logger.i('ℹ️ Hive migration disabled - import() not supported in Dart');
    } catch (e) {
      _logger.e('❌ Error migrating from Hive: $e');
      // Không throw error, migration failure không nên block app
    }
  }
}

// Global instance
final secureStorage = SecureStorageService();
