import 'package:Foodtour/ui/auth/register/provider/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../widgets/shared/field.dart';
import '../login/login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerNotifierProvider);
    final notifier = ref.read(registerNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(32),
                  // const Text(
                  //   "Chào mừng!",
                  //   style: TextStyle(
                  //     fontSize: 32,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                   Text(
                    "Chào mừng!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "Hãy tạo tài khoản mới để bắt đầu hành trình của bạn",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Gap(32),

                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "Email của bạn",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains("@")) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),
                  const Gap(16),

                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: "Mật khẩu",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Mật khẩu tối thiểu 6 ký tự";
                      }
                      return null;
                    },
                  ),
                  const Gap(16),

                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    hintText: "Nhập lại mật khẩu",
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Mật khẩu nhập lại không khớp";
                      }
                      return null;
                    },
                  ),
                  const Gap(32),

                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: state.isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          await notifier.register(
                            username: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      child: state.isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                          : const Text(
                        "Đăng ký",
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                  const Gap(24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Đã có tài khoản? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
