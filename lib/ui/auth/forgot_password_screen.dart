// lib/ui/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/themes/text_style.dart';
import '../../services/auth_service.dart';
import '../../widgets/dialogs/dialogs.dart';

/// Màn hình quên mật khẩu
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.sendPasswordResetEmail(_emailController.text.trim());

      if (mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Email đã gửi',
          message: 'Vui lòng kiểm tra email để đặt lại mật khẩu.',
          onPressed: () => Navigator.of(context).pop(),
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          message: 'Gửi email thất bại: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Gap(20.h),

                // Icon
                FadeInDown(
                  duration: Duration(milliseconds: 800),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 64.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Gap(30.h),

                // Title
                FadeInDown(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 200),
                  child: Text(
                    'Quên mật khẩu?',
                    style: k2d600.s24,
                  ),
                ),
                Gap(8.h),

                // Description
                FadeInDown(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    'Nhập email của bạn để nhận link đặt lại mật khẩu.',
                    style: k2d400.s14.grey600ts,
                  ),
                ),
                Gap(40.h),

                // Email field
                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                        child: Text('Email', style: k2d600.s14),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'example@gmail.com',
                          hintStyle: k2d400.s14.grey600ts.copyWith(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.redAccent, size: 20.sp),
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Vui lòng nhập email';
                          if (!_isValidEmail(value.trim())) return 'Email không hợp lệ';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Gap(30.h),

                // Send button
                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 500),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: Size(double.infinity, 55.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                      elevation: 2,
                    ),
                    onPressed: _isLoading ? null : _sendResetEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('GỬI EMAIL', style: k2d600.s16.white),
                  ),
                ),
                Gap(20.h),

                // Back to login
                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nhớ mật khẩu?', style: k2d400.s14),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Đăng nhập', style: k2d600.s14.red500ts),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
