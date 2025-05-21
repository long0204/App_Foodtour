import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/route.dart';
import '../../../../services/auth_service.dart';
import '../../../../utils/genaratekey.dart';

part 'notifier.g.dart';
part 'state.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    if (!isValidEmail(username)) {
      state = state.copyWith(error: "Email không đúng định dạng @gmail.com");
      return;
    }

    if (!isValidPassword(password)) {
      state = state.copyWith(
          error:
          "Mật khẩu phải có ít nhất 6 ký tự, 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt");
      return;
    }

    final key = generateKey(20);
    state = state.copyWith(isLoading: true, error: null);

    try {
      await authService.register(
        username: username,
        password: password,
        key: key,
      );

      AppRouter.setIsLoggedIn(true);
      push(onboardingRoute);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: "Đăng ký thất bại: ${e.toString()}",
        isLoading: false,
      );
    }
  }

  bool isValidEmail(String email) => email.endsWith('@gmail.com');

  bool isValidPassword(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]).{6,}$');
    return regex.hasMatch(password);
  }
}
