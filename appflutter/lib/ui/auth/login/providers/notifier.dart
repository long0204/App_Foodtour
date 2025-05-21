import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/route.dart';
import '../../../../services/auth_service.dart';
import 'state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = state.copyWith(status: LoginStatus.error, error: "Vui lòng điền đầy đủ thông tin");
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, error: null);

    try {
      await authService.login(username, password);
      AppRouter.setIsLoggedIn(true);
      push(homeRoute);
      state = state.copyWith(status: LoginStatus.success);
    } catch (e) {
      state = state.copyWith(status: LoginStatus.error, error: e.toString());
    }
  }
}

final loginNotifierProvider =
NotifierProvider<LoginNotifier, LoginState>(() => LoginNotifier());
