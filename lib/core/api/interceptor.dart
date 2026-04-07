import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/secure_storage_service.dart';

class AppInterceptor extends InterceptorsWrapper {
  final SecureStorageService secureStorage;
  
  // Rate limiting
  final Map<String, DateTime> _lastRequestTime = {};
  final Duration _minInterval = const Duration(milliseconds: 500);
  final int _maxRetries = 3;
  
  AppInterceptor({required this.secureStorage});
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Rate limiting check
    final key = '${options.method}_${options.path}';
    final lastTime = _lastRequestTime[key];
    
    if (lastTime != null) {
      final diff = DateTime.now().difference(lastTime);
      if (diff < _minInterval) {
        debugPrint('⚠️ [RATE LIMIT] Request too fast: $key');
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Too many requests. Please wait.',
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
    
    _lastRequestTime[key] = DateTime.now();
    
    // Try to get token from secure storage first
    String? token = await secureStorage.getAuthToken();
    
    // Fallback to Firebase if no token in secure storage
    if (token == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        token = await user.getIdToken();
        // Save to secure storage for next time
        if (token != null) {
          await secureStorage.saveAuthToken(token);
        }
      }
    }
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    debugPrint('🌐 [API REQ] ${options.method} ${options.uri}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [API RES] ${response.statusCode} ${response.requestOptions.path}');
    debugPrint('📦 [DATA]: ${response.data}'); // In toàn bộ cục JSON ra Log
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ [API ERR] ${err.response?.statusCode} ${err.requestOptions.path}');

    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      debugPrint("⛔ Token không hợp lệ hoặc hết hạn!");
      // TODO: Trigger logout or token refresh
    }
    
    // Handle 429 Too Many Requests with retry
    if (err.response?.statusCode == 429) {
      debugPrint("⚠️ [RATE LIMIT] Too many requests from server");
      
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < _maxRetries) {
        debugPrint("🔄 [RETRY] Attempt ${retryCount + 1}/$_maxRetries");
        
        // Get retry-after header or use exponential backoff
        final retryAfter = err.response?.headers.value('retry-after');
        final delaySeconds = retryAfter != null 
            ? int.tryParse(retryAfter) ?? (retryCount + 1) * 2
            : (retryCount + 1) * 2;
        
        // Wait and retry
        Future.delayed(Duration(seconds: delaySeconds), () {
          err.requestOptions.extra['retryCount'] = retryCount + 1;
          handler.resolve(err.response!);
        });
        return;
      } else {
        debugPrint("❌ [RETRY] Max retries reached");
      }
    }

    return handler.next(err);
  }
}