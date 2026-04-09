// lib/core/error/error_messages.dart
import 'package:dio/dio.dart';

/// Service để map errors thành user-friendly messages
class ErrorMessages {
  /// Get user-friendly error message from exception
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _getDioErrorMessage(error);
    }
    
    if (error is String) {
      return error;
    }
    
    return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
  }

  /// Get error message from DioException
  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Kết nối quá chậm. Vui lòng kiểm tra mạng và thử lại.';
      
      case DioExceptionType.sendTimeout:
        return 'Gửi dữ liệu quá chậm. Vui lòng thử lại.';
      
      case DioExceptionType.receiveTimeout:
        return 'Nhận dữ liệu quá chậm. Vui lòng thử lại.';
      
      case DioExceptionType.badCertificate:
        return 'Chứng chỉ bảo mật không hợp lệ.';
      
      case DioExceptionType.badResponse:
        return _getStatusCodeMessage(error.response?.statusCode);
      
      case DioExceptionType.cancel:
        return 'Yêu cầu đã bị hủy.';
      
      case DioExceptionType.connectionError:
        return 'Không thể kết nối. Vui lòng kiểm tra kết nối mạng.';
      
      case DioExceptionType.unknown:
        return 'Lỗi không xác định. Vui lòng thử lại.';
      
      default:
        return 'Đã xảy ra lỗi. Vui lòng thử lại.';
    }
  }

  /// Get error message from HTTP status code
  static String _getStatusCodeMessage(int? statusCode) {
    if (statusCode == null) {
      return 'Không nhận được phản hồi từ máy chủ.';
    }

    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ.';
      case 401:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền truy cập.';
      case 404:
        return 'Không tìm thấy dữ liệu.';
      case 408:
        return 'Yêu cầu quá thời gian chờ.';
      case 429:
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
      case 500:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      case 502:
        return 'Máy chủ không phản hồi. Vui lòng thử lại sau.';
      case 503:
        return 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';
      case 504:
        return 'Máy chủ quá tải. Vui lòng thử lại sau.';
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return 'Yêu cầu không hợp lệ (Mã lỗi: $statusCode).';
        } else if (statusCode >= 500) {
          return 'Lỗi máy chủ (Mã lỗi: $statusCode). Vui lòng thử lại sau.';
        }
        return 'Đã xảy ra lỗi (Mã lỗi: $statusCode).';
    }
  }

  /// Get error title based on error type
  static String getErrorTitle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Kết nối chậm';
        
        case DioExceptionType.connectionError:
          return 'Không có kết nối';
        
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return 'Phiên hết hạn';
          } else if (statusCode != null && statusCode >= 500) {
            return 'Lỗi máy chủ';
          }
          return 'Lỗi';
        
        default:
          return 'Lỗi';
      }
    }
    
    return 'Lỗi';
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError;
    }
    return false;
  }

  /// Check if error requires re-authentication
  static bool requiresReAuth(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode == 401;
    }
    return false;
  }
}
