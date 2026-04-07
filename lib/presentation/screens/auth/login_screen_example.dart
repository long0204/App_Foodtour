// lib/presentation/screens/auth/login_screen_example.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

/// Example Login Screen using Riverpod
/// This is a reference implementation showing how to use auth providers
class LoginScreenExample extends ConsumerStatefulWidget {
  const LoginScreenExample({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreenExample> createState() => _LoginScreenExampleState();
}

class _LoginScreenExampleState extends ConsumerState<LoginScreenExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authStateProvider.notifier).login(
              _emailController.text.trim(),
              _passwordController.text,
            );
        
        // Navigation will be handled by listener
      } catch (e) {
        // Error will be shown by listener
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state
    final authState = ref.watch(authStateProvider);
    
    // Listen to auth state changes for side effects
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      // Show error if any
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        // Clear error after showing
        ref.read(authStateProvider.notifier).clearError();
      }
      
      // Navigate to home if authenticated
      if (next.isAuthenticated && next.user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email không được để trống';
                    }
                    if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                  enabled: !authState.isLoading,
                ),
                
                const SizedBox(height: 16),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                  enabled: !authState.isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Login button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Sign up link
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                  child: const Text('Chưa có tài khoản? Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
