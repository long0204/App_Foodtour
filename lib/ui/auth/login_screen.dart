// lib/ui/auth/login_screen.dart
import 'package:Foodtour/ui/auth/providers/auth_notifier.dart';
import 'package:Foodtour/ui/auth/widgets/email_auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../core/route.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.shared.logo.image(height: 100.h),
            Gap(20.h),
            Text("Chào mừng tới FoodTour", style: k2d600.s24.red500ts),
            Gap(40.h),

            _buildAuthButton(
              Icons.email,
              "Tiếp tục với Email",
              Colors.grey[800]!,
              // Dùng context.push của GoRouter
                  () => push(emailAuthRoute),
            ),

            Gap(15.h),
            _buildAuthButton(
                Icons.g_mobiledata_rounded,
                "Đăng nhập với Google",
                Colors.blue,
                    () => ref.read(authNotifierProvider.notifier).loginGoogle()
            ),

            Gap(15.h),
            _buildAuthButton(
                Icons.apple,
                "Đăng nhập với Apple",
                Colors.black,
                    () => ref.read(authNotifierProvider.notifier).loginApple()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: k2d500.s14.white),
      onPressed: onTap,
    );
  }
}