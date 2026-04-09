import 'package:dio/dio.dart';
import '../../config/constants/env.dart';
import '../../services/secure_storage_service.dart';
import '../network/network_info.dart';
import '../network/retry_interceptor.dart';
import 'interceptor.dart';

class ApiClient {
  // 1. Chuyển sang dùng final thay vì late để an toàn hơn
  final Dio _dio;
  final SecureStorageService secureStorage;

  ApiClient({required this.secureStorage}) :
        _dio = Dio(BaseOptions(
          baseUrl: ENV.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          contentType: 'application/json',
        )) {

    _dio.interceptors.addAll([
      AppInterceptor(secureStorage: secureStorage),
      RetryInterceptor(
        dio: _dio,
        networkInfo: networkInfo,
        maxRetries: 3,
        retryDelay: const Duration(seconds: 2),
      ),
    ]);
  }

  Dio getDio() => _dio;

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      return response.data;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('API GET error: $e');
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      return response.data;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('API POST error: $e');
    }
  }
}

late final ApiClient apiClient;