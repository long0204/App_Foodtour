// lib/domain/repositories/auth_repository.dart
import '../entities/user_entity.dart';

/// Authentication repository interface
/// Defines the contract for authentication operations
/// Implementation will be in data layer
abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserEntity> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<UserEntity> signUpWithEmail(String email, String password);

  /// Sign in with Google
  Future<UserEntity> signInWithGoogle();

  /// Sign in with Apple
  Future<UserEntity> signInWithApple();

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoUrl});
}
