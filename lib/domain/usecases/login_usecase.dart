// lib/domain/usecases/login_usecase.dart
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../utils/validators.dart';

/// Use case for user login
/// Contains business logic for authentication
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login with email and password
  /// Validates input before calling repository
  Future<UserEntity> call(String email, String password) async {
    // Validate email
    final emailError = Validators.email(email);
    if (emailError != null) {
      throw Exception(emailError);
    }

    // Validate password
    final passwordError = Validators.password(password);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    // Call repository
    return await repository.signInWithEmail(email, password);
  }
}
