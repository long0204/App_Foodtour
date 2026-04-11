import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../providers/tab_provider.dart';
import '../../../core/providers/api_client_provider.dart';

final authServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userFirestoreProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) => snapshot.data());
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(const AsyncData(null));

  Future<void> loginGoogle() async {
    state = const AsyncLoading();

    try {
      final result = await _authService.signInWithGoogle();

      if (result != null && result.user != null) {
        state = const AsyncData(null);
        _ref.read(tabIndexProvider.notifier).state = 0;
        print("✅ Login Google successful, navigating to home");
      } else {
        state = AsyncError("Đăng nhập bị hủy", StackTrace.current);
        print("❌ Login Google cancelled");
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
      print("❌ Login Google error: $e");
    }
  }

  Future<void> loginApple() async {
    state = const AsyncLoading();

    try {
      final result = await _authService.signInWithApple();

      if (result != null && result.user != null) {
        state = const AsyncData(null);
        _ref.read(tabIndexProvider.notifier).state = 0;
        print("✅ Login Apple successful, navigating to home");
      } else {
        state = AsyncError("Đăng nhập bị hủy", StackTrace.current);
        print("❌ Login Apple cancelled");
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
      print("❌ Login Apple error: $e");
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() => _authService.signInWithEmail(email, password));

    if (result is AsyncData && result.value != null) {
      _ref.read(tabIndexProvider.notifier).state = 0;
    }

    state = result;
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() => _authService.signUpWithEmail(email, password));

    if (result is AsyncData && result.value != null) {
      _ref.read(tabIndexProvider.notifier).state = 0;
    }

    state = result;
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref,
  );
});