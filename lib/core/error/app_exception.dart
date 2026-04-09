// lib/core/error/app_exception.dart

/// Base exception class for app-specific errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return NetworkException(
      message: 'Không có kết nối internet. Vui lòng kiểm tra lại.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return NetworkException(
      message: 'Kết nối quá chậm. Vui lòng thử lại.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError() {
    return NetworkException(
      message: 'Lỗi máy chủ. Vui lòng thử lại sau.',
      code: 'SERVER_ERROR',
    );
  }
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.notLoggedIn() {
    return AuthException(
      message: 'Vui lòng đăng nhập để tiếp tục.',
      code: 'NOT_LOGGED_IN',
    );
  }

  factory AuthException.sessionExpired() {
    return AuthException(
      message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthException.invalidCredentials() {
    return AuthException(
      message: 'Email hoặc mật khẩu không đúng.',
      code: 'INVALID_CREDENTIALS',
    );
  }
}

/// Data related exceptions
class DataException extends AppException {
  DataException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DataException.notFound() {
    return DataException(
      message: 'Không tìm thấy dữ liệu.',
      code: 'NOT_FOUND',
    );
  }

  factory DataException.invalidFormat() {
    return DataException(
      message: 'Dữ liệu không hợp lệ.',
      code: 'INVALID_FORMAT',
    );
  }
}

/// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.required(String field) {
    return ValidationException(
      message: 'Vui lòng nhập $field.',
      code: 'REQUIRED',
      fieldErrors: {field: 'Trường này là bắt buộc'},
    );
  }

  factory ValidationException.invalidEmail() {
    return ValidationException(
      message: 'Email không hợp lệ.',
      code: 'INVALID_EMAIL',
      fieldErrors: {'email': 'Email không đúng định dạng'},
    );
  }
}

/// Permission related exceptions
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory PermissionException.denied(String permission) {
    return PermissionException(
      message: 'Ứng dụng cần quyền $permission để hoạt động.',
      code: 'PERMISSION_DENIED',
    );
  }
}

/// Helper to convert generic errors to AppException
AppException toAppException(dynamic error) {
  if (error is AppException) return error;

  final errorString = error.toString().toLowerCase();

  // Network errors
  if (errorString.contains('socket') || 
      errorString.contains('network') ||
      errorString.contains('connection')) {
    return NetworkException.noConnection();
  }

  if (errorString.contains('timeout')) {
    return NetworkException.timeout();
  }

  // Auth errors
  if (errorString.contains('unauthorized') || 
      errorString.contains('unauthenticated')) {
    return AuthException.notLoggedIn();
  }

  if (errorString.contains('token') || 
      errorString.contains('expired')) {
    return AuthException.sessionExpired();
  }

  // Default
  return DataException(
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    code: 'UNKNOWN',
    originalError: error,
  );
}
