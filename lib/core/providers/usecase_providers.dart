// lib/core/providers/usecase_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../di/injection.dart';

/// Use case providers
/// These provide access to use cases from DI container

/// Login use case provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return getIt<LoginUseCase>();
});

/// Logout use case provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return getIt<LogoutUseCase>();
});

// TODO: Add more use case providers as needed
