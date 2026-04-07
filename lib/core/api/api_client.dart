import 'package:dio/dio.dart';
import '../../config/constants/env.dart';
import '../../services/secure_storage_service.dart';
import 'interceptor.dart';

class ApiClient {
  late Dio _dio;
  final SecureStorageService secureStorage;

  ApiClient({required this.secureStorage}) {
    _dio = Dio(BaseOptions(
      baseUrl: ENV.baseUrl,
      // connectTimeout: const Duration(seconds: 15),
      // receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ))..interceptors.add(AppInterceptor(secureStorage: secureStorage));
  }

  Dio getDio() => _dio;

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      // ✅ Null check added
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? e;
    } catch (e) {
      throw Exception('API GET error: $e');
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      // ✅ Null check added
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? e;
    } catch (e) {
      throw Exception('API POST error: $e');
    }
  }

}

// Global instance - will be initialized in main.dart
late final ApiClient apiClient;