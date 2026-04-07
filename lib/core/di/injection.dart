// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/local/secure_storage_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../services/secure_storage_service.dart';
import '../api/api_client.dart';

/// Dependency Injection container
final getIt = GetIt.instance;

/// Setup all dependencies
/// Call this in main.dart before runApp()
Future<void> setupDependencies() async {
  // ==================== Core ====================
  
  // Secure Storage Service (must be first)
  final secureStorage = SecureStorageService();
  
  // API Client with secure storage
  apiClient = ApiClient(secureStorage: secureStorage);
  getIt.registerLazySingleton<ApiClient>(() => apiClient);
  
  // ==================== Data Sources ====================
  
  // Local Data Sources
  getIt.registerLazySingleton<SecureStorageDataSource>(
    () => SecureStorageDataSourceImpl(),
  );
  
  // Remote Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  
  // ==================== Repositories ====================
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<SecureStorageDataSource>(),
    ),
  );
  
  // ==================== Use Cases ====================
  
  // Auth Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
}

/// Clear all dependencies (for testing)
void clearDependencies() {
  getIt.reset();
}
