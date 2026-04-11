// lib/ui/auth/biometric_login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../providers/tab_provider.dart';
import '../../services/biometric_service.dart';
import '../../core/route.dart';

class BiometricLoginScreen extends ConsumerStatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  ConsumerState<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends ConsumerState<BiometricLoginScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateWithBiometric();
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);

    try {
      final authenticated = await biometricService.authenticate(
        reason: 'Xác thực để đăng nhập vào FoodTour',
      );

      if (authenticated) {
        // Biometric success - navigate to home
        ref.read(tabIndexProvider.notifier).state = 0;
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Đăng nhập thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Biometric failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Xác thực thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
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
                  Gap(40.h),

                  // Biometric icon
                  FadeIn(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 200),
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.fingerprint,
                        size: 80.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gap(30.h),

                  // Title
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 400),
                    child: Text(
                      'Đăng nhập bằng sinh trắc học',
                      style: k2d600.s24.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(12.h),

                  // Description
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 500),
                    child: Text(
                      'Chạm vào cảm biến để xác thực',
                      style: k2d400.s14.white.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(50.h),

                  // Retry button
                  if (!_isAuthenticating)
                    FadeInUp(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 600),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFDC143C),
                          minimumSize: Size(double.infinity, 56.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 8,
                        ),
                        icon: Icon(Icons.fingerprint, size: 24.sp),
                        label: Text('Thử lại', style: k2d600.s16),
                        onPressed: _authenticateWithBiometric,
                      ),
                    ),

                  // Loading indicator
                  if (_isAuthenticating)
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),

                  Gap(20.h),

                  // Use password instead
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 700),
                    child: TextButton(
                      onPressed: () => pop(),
                      child: Text(
                        'Dùng mật khẩu thay thế',
                        style: k2d500.s14.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
