// lib/core/network/retry_interceptor.dart
import 'package:dio/dio.dart';
import 'network_info.dart';

/// Interceptor để tự động retry khi request fail
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final NetworkInfo networkInfo;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    required this.networkInfo,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if should retry
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Get retry count from request
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Max retries reached
    if (retryCount >= maxRetries) {
      print('❌ Max retries ($maxRetries) reached for ${err.requestOptions.path}');
      return handler.next(err);
    }

    // Check network connection
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      print('❌ No internet connection, cannot retry');
      return handler.next(err);
    }

    // Wait before retry
    print('🔄 Retrying request (${retryCount + 1}/$maxRetries) after ${retryDelay.inSeconds}s...');
    await Future.delayed(retryDelay);

    // Increment retry count
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    // Retry request
    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Check if request should be retried
  bool _shouldRetry(DioException err) {
    // Don't retry on client errors (4xx)
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 400 && statusCode < 500) {
        return false;
      }
    }

    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on server errors (5xx)
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 500) {
        return true;
      }
    }

    return false;
  }
}
