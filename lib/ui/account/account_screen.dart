import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../core/route.dart';
import '../auth/providers/auth_notifier.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userFirestoreProvider);

    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: userDataAsync.when(
          data: (userData) => SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, userData), // Truyền dữ liệu Firestore vào đây
                Padding(
                  padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildMenuSection(
                    title: "Hoạt động của tôi",
                    items: [
                      _buildMenuItem(Icons.history, "Lịch sử ăn uống", Colors.blue, () {}),
                      _buildMenuItem(Icons.star_outline, "Quán ăn đã đánh giá", Colors.orange, () {}),
                      _buildMenuItem(Icons.favorite_border, "Địa điểm đã lưu", Colors.red, () {}),
                    ],
                  ),
                  Gap(20.h),
                  _buildMenuSection(
                    title: "Cài đặt ứng dụng",
                    items: [
                      _buildMenuItem(Icons.person_outline, "Chỉnh sửa thông tin", Colors.teal, () {
                        // Điều hướng sang màn hình chỉnh sửa
                        push('/edit-profile');
                      }),
                      _buildMenuItem(Icons.notifications_none, "Thông báo", Colors.purple, () {}),
                      _buildMenuItem(Icons.language, "Ngôn ngữ", Colors.brown, () {}),
                    ],
                  ),
                  Gap(30.h),
                  // NÚT ĐĂNG XUẤT
                  _buildLogoutButton(context, ref),
                  Gap(100.h), // Tránh bị che bởi BottomNavigationBar
                ],
              ),
            ),
          ],
        ),), loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Lỗi: $e")),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? userData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
              color: Colors.redAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: (userData?['avatar'] != null)
                ? NetworkImage(userData!['avatar'])
                : Assets.images.user.avtDefault.provider(),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Fix lỗi crash Expanded
              children: [
                Text(
                  userData?['fullname'] ?? "Người dùng FoodTour", // Dữ liệu realtime
                  style: k2d600.s20.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userData?['username'] ?? "", // Email lấy từ Firestore
                  style: k2d400.s14.white,
                ),
                Text(
                  userData?['fullname'] ?? "",
                  style: k2d400.s14.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  "Cấp độ: Người sành ăn 🌟",
                  style: k2d400.s12.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined, color: Colors.white),
            onPressed: () {
              push(editProfileRoute);
            },
          )
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 10.h),
          child: Text(title, style: k2d600.s14.grey600ts),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(title, style: k2d500.s14),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          foregroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: Text("Đăng xuất", style: k2d600.s16),
        onPressed: () => _showLogoutDialog(context, ref),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có thực sự muốn đăng xuất?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout(); // Gọi hàm logout
              Navigator.pop(context);
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}