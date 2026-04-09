// lib/core/providers/api_client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../../services/secure_storage_service.dart';

/// API Client Provider
/// Provides a singleton instance of ApiClient with secure storage
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(secureStorage: secureStorage);
});
