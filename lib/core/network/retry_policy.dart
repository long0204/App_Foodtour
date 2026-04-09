// lib/core/network/retry_policy.dart
import 'dart:async';
import 'package:dio/dio.dart';

/// Retry policy for failed network requests
class RetryPolicy {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;

  const RetryPolicy({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
  });

  /// Execute function with retry logic
  Future<T> execute<T>(Future<T> Function() function) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await function();
      } catch (error) {
        attempt++;

        // Check if should retry
        if (!_shouldRetry(error, attempt)) {
          rethrow;
        }

        // Wait before retry with exponential backoff
        await Future.delayed(delay);
        
        // Calculate next delay
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).toInt(),
        );
        
        // Cap at max delay
        if (delay > maxDelay) {
          delay = maxDelay;
        }

        print('🔄 Retry attempt $attempt/$maxRetries after ${delay.inSeconds}s');
      }
    }
  }

  /// Check if error is retryable
  bool _shouldRetry(dynamic error, int attempt) {
    // Max retries reached
    if (attempt >= maxRetries) {
      return false;
    }

    // DioException handling
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;

        case DioExceptionType.badResponse:
          // Retry on 5xx server errors and 429 rate limit
          final statusCode = error.response?.statusCode;
          return statusCode != null && 
                 (statusCode >= 500 || statusCode == 429);

        default:
          return false;
      }
    }

    // Generic network errors
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socket') ||
           errorString.contains('network') ||
           errorString.contains('connection') ||
           errorString.contains('timeout');
  }
}

/// Dio interceptor for automatic retry
class RetryInterceptor extends Interceptor {
  final RetryPolicy policy;

  RetryInterceptor({RetryPolicy? policy})
      : policy = policy ?? const RetryPolicy();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!policy._shouldRetry(err, 0)) {
      return handler.next(err);
    }

    try {
      final response = await policy.execute(() async {
        return await _retry(err);
      });
      
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  Future<Response> _retry(DioException err) async {
    final requestOptions = err.requestOptions;
    
    return await Dio().request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
}

/// Global retry policy provider
const defaultRetryPolicy = RetryPolicy(
  maxRetries: 3,
  initialDelay: Duration(seconds: 1),
  backoffMultiplier: 2.0,
  maxDelay: Duration(seconds: 30),
);
