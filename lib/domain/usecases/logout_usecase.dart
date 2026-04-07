// lib/domain/usecases/logout_usecase.dart
import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  Future<void> call() async {
    await repository.signOut();
  }
}
