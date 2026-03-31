import 'package:dio/dio.dart';
import '../../config/constants/env.dart';
import 'interceptor.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ENV.baseUrl,
      // connectTimeout: const Duration(seconds: 15),
      // receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ))..interceptors.add(AppInterceptor());
  }

  Dio getDio() => _dio;

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

}

final apiClient = ApiClient();