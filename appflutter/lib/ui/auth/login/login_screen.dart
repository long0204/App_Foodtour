import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/route.dart';
import '../../../widgets/shared/field.dart';
import 'providers/notifier.dart';
import 'providers/state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late final ProviderSubscription<LoginState> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<LoginState>(
      loginNotifierProvider,
          (prev, next) {
        if (next.status == LoginStatus.success) {
          context.go(rootRoute);
        } else if (next.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error ?? "Đăng nhập thất bại")),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _subscription.close();
    super.dispose();
  }

  void _handleLogin() {
    ref.read(loginNotifierProvider.notifier).login(
      _userCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final isLoading = state.status == LoginStatus.loading;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset(
          //   'assets/images/food_bg.jpg',
          //   fit: BoxFit.cover,
          //   color: Colors.black.withOpacity(0.5),
          //   colorBlendMode: BlendMode.darken,
          // ),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap( 48),
                    const Center(
                      child: Icon(Icons.restaurant_menu,
                          size: 72, color: Colors.orangeAccent),
                    ),
                    const Gap(12),
                    Text(
                      "Chào mừng quay lại FoodTour!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(32),

                    CustomTextFormField(
                      controller: _userCtrl,
                      hintText: "Email",
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return "Email không hợp lệ";
                        }
                        return null;
                      },
                    ),
                    const Gap( 16),

                    CustomTextFormField(
                      controller: _passCtrl,
                      hintText: "Mật khẩu",
                      obscureText: true,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Mật khẩu tối thiểu 6 ký tự";
                        }
                        return null;
                      },
                    ),
                    const Gap( 24),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : const Text("Đăng nhập",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const Gap(24),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Chưa có tài khoản? ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Đăng ký ngay',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Colors.orangeAccent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(registerRoute);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
