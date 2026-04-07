// lib/core/providers/repository_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../di/injection.dart';

/// Repository providers
/// These provide access to repositories from DI container

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

// TODO: Add more repository providers as needed
// final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
//   return getIt<RestaurantRepository>();
// });
