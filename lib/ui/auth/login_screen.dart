import 'package:Foodtour/ui/auth/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart'; // ✅ NEW: For animations

import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../core/route.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    
    // Listen for errors
    ref.listen<AsyncValue<void>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thất bại: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    
    return Scaffold(
      body: Stack(
        children: [
          // ✅ NEW: Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDC143C), // Red
                  Color(0xFFFF6B35), // Orange
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: Duration(milliseconds: 800),
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Assets.icons.favicon.icRound.image(height: 80.h),
                      ),
                    ),
                    Gap(30.h),

                    FadeInDown(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          Text(
                            "Chào mừng tới",
                            style: k2d500.s16.white,
                          ),
                          Gap(8.h),
                          Text(
                            "FoodTour",
                            style: k2d600.s24.white,
                          ),
                          Gap(8.h),
                          Text(
                            "Khám phá ẩm thực xung quanh bạn",
                            style: k2d400.s14.white.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Gap(50.h),

                    FadeInUp(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 400),
                      child: _buildAuthButton(
                        Icons.email,
                        "Tiếp tục với Email",
                        Colors.white,
                        Color(0xFFDC143C),
                        () => push(emailAuthRoute),
                      ),
                    ),
                    Gap(15.h),
                    
                    FadeInUp(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 500),
                      child: _buildAuthButton(
                        Icons.g_mobiledata_rounded,
                        "Đăng nhập với Google",
                        Color(0xFF4285F4),
                        Colors.white,
                        () => ref.read(authNotifierProvider.notifier).loginGoogle(),
                      ),
                    ),
                    Gap(15.h),
                    
                    FadeInUp(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 600),
                      child: _buildAuthButton(
                        Icons.apple,
                        "Đăng nhập với Apple",
                        Colors.black,
                        Colors.white,
                        () => ref.read(authNotifierProvider.notifier).loginApple(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Loading overlay
          if (authState.isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    Gap(16.h),
                    Text(
                      'Đang đăng nhập...',
                      style: k2d500.s14.white,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(
      IconData icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        icon: Icon(icon, color: textColor, size: 24.sp),
        label: Text(
          label,
          style: k2d600.s14.copyWith(color: textColor),
        ),
        onPressed: onTap,
      ),
    );
  }
}
