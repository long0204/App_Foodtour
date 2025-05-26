import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import '../../config/constants/strings.dart';
import '../../core/route.dart';
import '../../services/auth_service.dart';
import 'package:Foodtour/ui/account/providers/notifier.dart';

import '../auth/provider/auth_notifier.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarState = ref.watch(avatarNotifierProvider);
    final avatarNotifier = ref.read(avatarNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFEEFEF), // nền hồng nhạt
      appBar: AppBar(
        backgroundColor: Colors.red.shade100,
        title: const Text('Tài khoản'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Gap(24),
          Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarState.avatarUrl != null
                        ? NetworkImage(avatarState.avatarUrl!)
                        : const AssetImage('asset/images/user/avt_default.png')
                    as ImageProvider,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text('Chọn từ thư viện'),
                                onTap: () {
                                  Navigator.pop(context);
                                  avatarNotifier.pickAndUploadImage(ImageSource.gallery);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Chụp ảnh'),
                                onTap: () {
                                  Navigator.pop(context);
                                  avatarNotifier.pickAndUploadImage(ImageSource.camera);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          if (avatarState.isLoading)
            const CircularProgressIndicator(),
          const Gap(16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildOptionCard(
                    icon: Icons.person,
                    label: "Thông tin tài khoản",
                    onTap: () {},
                  ),
                  const Gap(12),
                  _buildOptionCard(
                    icon: Icons.lock,
                    label: "Đổi mật khẩu",
                    onTap: () {},
                  ),
                  const Gap(12),
                  _buildOptionCard(
                    icon: Icons.star_rate,
                    label: "Đánh giá ứng dụng",
                    onTap: () async {final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                    // Platform.isAndroid
                    // if (await inAppReview.isAvailable()) {
                    //   inAppReview.requestReview();
                    // } else
                    inAppReview.openStoreListing(appStoreId: Strings.kAppStoreId);
                    }},
                  ),
                  const Spacer(),
                  _buildOptionCard(
                    icon: Icons.logout,
                    label: "Đăng xuất",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Xác nhận',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Gap(16),
                                      const Text(
                                        'Bạn có chắc muốn đăng xuất không?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16, color: Colors.black54),
                                      ),
                                      const Gap(24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              backgroundColor: Colors.grey.shade400,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              backgroundColor: Colors.red.shade400,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -40,
                                  left: 0,
                                  right: 0,
                                  child:
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Lottie.asset(
                                        'asset/lottie/warning.json',
                                        repeat: true,
                                        animate: true,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          );
                        },
                      );
                      if (confirm == true) {
                        await authService.logout();
                        AppRouter.setIsLoggedIn(false);
                        push(loginRoute);
                        authNotifier.logout();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: iconColor),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
