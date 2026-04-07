// lib/core/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

/// Global error handler for the app
/// Catches all uncaught errors and logs them to Crashlytics
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();

  final _logger = Logger();

  /// Initialize global error handlers
  void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.e('❌ Flutter Error: ${details.exception}');
      _logger.e('Stack trace: ${details.stack}');
      
      // Log to Crashlytics
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      
      // In debug mode, also print to console
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Handle errors outside Flutter framework (async errors)
    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.e('❌ Platform Error: $error');
      _logger.e('Stack trace: $stack');
      
      // Log to Crashlytics
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
        reason: 'Uncaught platform error',
      );
      
      return true; // Handled
    };
    
    _logger.i('✅ Global error handler initialized');
  }

  /// Log a custom error
  void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    _logger.e('❌ Custom Error: $error');
    if (stackTrace != null) {
      _logger.e('Stack trace: $stackTrace');
    }
    
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  /// Log a custom message
  void log(String message) {
    _logger.i(message);
    FirebaseCrashlytics.instance.log(message);
  }

  /// Set user identifier for crash reports
  void setUserId(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
    _logger.i('✅ User ID set for crash reports: $userId');
  }

  /// Clear user identifier
  void clearUserId() {
    FirebaseCrashlytics.instance.setUserIdentifier('');
    _logger.i('✅ User ID cleared from crash reports');
  }

  /// Set custom key-value for crash reports
  void setCustomKey(String key, dynamic value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }
}

// Global instance
final errorHandler = GlobalErrorHandler();
