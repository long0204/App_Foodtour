import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'secure_storage_service.dart';

/// Service để quản lý biometric authentication
/// Hỗ trợ Face ID, Touch ID (iOS) và Fingerprint (Android)
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();
  final _logger = Logger();

  // Storage key
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Check xem device có hỗ trợ biometric không
  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      
      _logger.i('Can check biometrics: $canCheck');
      _logger.i('Device supported: $isDeviceSupported');
      
      return canCheck && isDeviceSupported;
    } catch (e) {
      _logger.e('Error checking biometrics: $e');
      return false;
    }
  }

  /// Lấy danh sách biometric types có sẵn
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _auth.getAvailableBiometrics();
      
      _logger.i('Available biometrics: $availableBiometrics');
      
      return availableBiometrics;
    } catch (e) {
      _logger.e('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate với biometric
  Future<bool> authenticate({
    String reason = 'Xác thực để đăng nhập',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      // Check if biometric is available
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        _logger.w('Biometric not available on this device');
        return false;
      }

      // Authenticate
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false, // Allow PIN/Pattern as fallback
        ),
      );

      if (authenticated) {
        _logger.i('✅ Biometric authentication successful');
      } else {
        _logger.w('❌ Biometric authentication failed');
      }

      return authenticated;
    } catch (e) {
      _logger.e('❌ Error during biometric authentication: $e');
      return false;
    }
  }

  /// Check xem user đã enable biometric chưa
  Future<bool> isBiometricEnabled() async {
    try {
      final enabled = await secureStorage.getBiometricEnabled();
      return enabled;
    } catch (e) {
      _logger.e('Error checking biometric enabled: $e');
      return false;
    }
  }

  /// Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      if (enabled) {
        // Verify biometric before enabling
        final authenticated = await authenticate(
          reason: 'Xác thực để bật đăng nhập sinh trắc học',
        );
        
        if (!authenticated) {
          throw Exception('Xác thực thất bại');
        }
      }
      
      await secureStorage.setBiometricEnabled(enabled);
      _logger.i('✅ Biometric ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _logger.e('❌ Error setting biometric enabled: $e');
      rethrow;
    }
  }

  /// Get biometric type name for display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Vân tay';
      case BiometricType.iris:
        return 'Mống mắt';
      case BiometricType.strong:
        return 'Sinh trắc học mạnh';
      case BiometricType.weak:
        return 'Sinh trắc học yếu';
      default:
        return 'Sinh trắc học';
    }
  }

  /// Get available biometric names as string
  Future<String> getAvailableBiometricNames() async {
    final biometrics = await getAvailableBiometrics();
    
    if (biometrics.isEmpty) {
      return 'Không có';
    }
    
    return biometrics
        .map((type) => getBiometricTypeName(type))
        .join(', ');
  }
}

// Global instance
final biometricService = BiometricService();
