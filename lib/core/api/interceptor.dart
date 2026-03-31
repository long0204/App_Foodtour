import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
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

    if (err.response?.statusCode == 401) {
      debugPrint("⛔ Token không hợp lệ hoặc hết hạn!");
      // Bạn có thể trigger đăng xuất ở đây nếu muốn
    }

    return handler.next(err);
  }
}