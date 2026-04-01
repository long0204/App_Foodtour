import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../providers/tab_provider.dart';

final authServiceProvider = Provider((ref) => AuthService());

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

    final result = await AsyncValue.guard(() => _authService.signInWithGoogle());

    if (result is AsyncData && result.value != null) {
      _ref.read(tabIndexProvider.notifier).state = 0;
    }

    state = result;
  }

  Future<void> loginApple() async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() => _authService.signInWithApple());

    if (result is AsyncData && result.value != null) {
      _ref.read(tabIndexProvider.notifier).state = 0;
    }

    state = result;
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