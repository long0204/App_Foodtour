import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../config/gen/assets.gen.dart';
import '../../../config/themes/text_style.dart';
import '../providers/auth_notifier.dart';

class EmailAuthScreen extends ConsumerStatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  ConsumerState<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<EmailAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _obscurePassword = true;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authNotifierProvider, (prev, next) {
      next.whenOrNull(error: (err, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi: ${err.toString()}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    });

    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER VÀ LOGO
                Center(
                  child: Assets.icons.favicon.icRound.image(height: 80.h),
                ),
                Gap(30.h),
                Text(
                  _isLogin ? "Chào mừng trở lại!" : "Tạo tài khoản mới",
                  style: k2d600.s24,
                ),
                Gap(8.h),
                Text(
                  _isLogin
                      ? "Đăng nhập để khám phá những quán ăn ngon quanh bạn."
                      : "Tham gia cộng đồng FoodTour để chia sẻ trải nghiệm.",
                  style: k2d400.s14.grey600ts,
                ),
                Gap(40.h),

                // 2. Ô NHẬP EMAIL
                _buildLabel("Email"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    hint: "example@gmail.com",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Vui lòng nhập email";
                    if (!_isValidEmail(value.trim())) return "Email không hợp lệ";
                    return null;
                  },
                ),
                Gap(20.h),

                // 3. Ô NHẬP MẬT KHẨU
                _buildLabel("Mật khẩu"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration(
                    hint: "••••••••",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) return "Mật khẩu tối thiểu 6 ký tự";
                    return null;
                  },
                ),

                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Quên mật khẩu?", style: k2d500.s13.red500ts),
                    ),
                  ),

                Gap(30.h),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: Size(double.infinity, 55.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    elevation: 2,
                  ),
                  onPressed: authState.isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text.trim();
                      final pass = _passwordController.text.trim();
                      if (_isLogin) {
                        ref.read(authNotifierProvider.notifier).loginWithEmail(email, pass);
                      } else {
                        ref.read(authNotifierProvider.notifier).registerWithEmail(email, pass);
                      }
                    }
                  },
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    _isLogin ? "ĐĂNG NHẬP" : "ĐĂNG KÝ",
                    style: k2d600.s16.white,
                  ),
                ),
                Gap(20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? "Bạn chưa có tài khoản?" : "Bạn đã có tài khoản?",
                      style: k2d400.s14,
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin ? "Đăng ký ngay" : "Đăng nhập",
                        style: k2d600.s14.red500ts,
                      ),
                    ),
                  ],
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(text, style: k2d600.s14),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon, bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: k2d400.s14.grey600ts.copyWith(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.redAccent, size: 20.sp),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20.sp),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      )
          : null,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}