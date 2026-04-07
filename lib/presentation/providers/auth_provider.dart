// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../core/providers/usecase_providers.dart';

/// Auth State
/// Represents the authentication state of the app
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  /// Create a copy with updated fields
  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  String toString() => 'AuthState(user: $user, isLoading: $isLoading, error: $error, isAuthenticated: $isAuthenticated)';
}

/// Auth State Notifier
/// Manages authentication state and business logic
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUseCase(email, password);
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await logoutUseCase();
      state = const AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Set user (for initial load)
  void setUser(UserEntity? user) {
    state = state.copyWith(
      user: user,
      isAuthenticated: user != null,
    );
  }
}

/// Auth State Provider
/// Main provider for authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
  );
});

/// Convenience Providers
/// These make it easier to access specific parts of auth state

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Get current user
final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authStateProvider).user;
});

/// Check if auth operation is loading
final authIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});

/// Get auth error message
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).error;
});
