import 'dart:io';
import 'dart:ui';
import 'package:Foodtour/widgets/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Foodtour/widgets/shared/cached_image.dart';

import '../../../config/themes/text_style.dart';
import '../../../services/remote_config_service.dart';
import '../../../services/cloudinary_service.dart'; // Phải có thư viện up ảnh của bạn
import '../../../widgets/helpers/showmanager.dart';
import '../../../widgets/shared/back_btn.dart';
import '../../auth/providers/auth_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _fullnameController;
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userFirestore = ref.read(userFirestoreProvider).value;
    _usernameController = TextEditingController(text: userFirestore?['username'] ?? '');
    _fullnameController = TextEditingController(text: userFirestore?['fullname'] ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Thay đổi ảnh đại diện", style: k2d500.s16),
              Gap(20.h),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text("Chọn từ thư viện"),
                onTap: () => _getImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.redAccent),
                title: const Text("Chụp ảnh mới"),
                onTap: () => _getImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userFirestore = ref.watch(userFirestoreProvider).value;
    final String currentAvatar = userFirestore?['avatar_url'] ?? ''; // Firebase đang lưu là 'avatar' hoặc 'avatar_url' tuỳ db của bạn

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.redAccent,
            leading: MyBackButton(),
            title: Text("Chỉnh sửa hồ sơ", style: k2d500.s16.white),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedImage(RemoteConfigService().imageAppbarHome,width: 50.w,height: 50.h, fit: BoxFit.cover),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3))),
                  ),
                  Positioned(
                    bottom: 30.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ZoomTap(
                        onTap: _showAvatarOptions,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                              ),
                              child: CircleAvatar(
                                radius: 60.r,
                                backgroundColor: Colors.white,
                                backgroundImage: _image != null
                                    ? FileImage(_image!)
                                    : (currentAvatar.isNotEmpty
                                    ? NetworkImage(currentAvatar)
                                    : null) as ImageProvider?,
                                child: _image == null && currentAvatar.isEmpty
                                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt, color: Colors.redAccent, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. PHẦN NHẬP LIỆU
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tên đăng nhập", style: k2d500.s16),
                  Gap(12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: TextField(
                      controller: _usernameController,
                      enabled: false, // Email/username thường không cho sửa
                      style: k2d400.s14.copyWith(color: Colors.grey),
                      decoration: InputDecoration(
                        hintText: "Nhập tên đăng nhập...",
                        prefixIcon: const Icon(Icons.alternate_email, color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                    ),
                  ),
                  Gap(20.h),

                  Text("Tên đầy đủ", style: k2d500.s16),
                  Gap(12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: TextField(
                      controller: _fullnameController,
                      style: k2d400.s14,
                      decoration: InputDecoration(
                        hintText: "Nhập tên đầy đủ...",
                        prefixIcon: const Icon(Icons.person, color: Colors.redAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                    ),
                  ),
                  Gap(40.h),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. NÚT LƯU THAY ĐỔI
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSyncUserData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              else
                const Icon(Icons.save, color: Colors.white),
              Gap(10.w),
              Text(_isLoading ? "Đang lưu..." : "Lưu thay đổi", style: k2d500.s16.white),
            ],
          ),
        ),
      ),
    );
  }

  // LOGIC UP ẢNH VÀ LƯU DATA CHUẨN CỦA BẠN (Dùng _isLoading và authService)
  Future<void> _handleSyncUserData() async {
    setState(() => _isLoading = true);

    try {
      String? newAvatarUrl;

      // 1. Up ảnh lên Cloudinary nếu người dùng có chọn ảnh mới
      if (_image != null) {
        newAvatarUrl = await cloudinaryService.uploadImage(_image!);
      }

      // 2. Gọi hàm updateProfile từ AuthService
      final authService = ref.read(authServiceProvider);
      await authService.updateProfile(
        fullname: _fullnameController.text.trim(),
        avatarUrl: newAvatarUrl,
      );

      if (mounted) {
        showManager.showToast( "Cập nhật hồ sơ thành công!");
        Navigator.pop(context);
        ref.invalidate(userFirestoreProvider); // Refresh lại data sau khi sửa
      }
    } catch (e) {
      if (mounted) {
        showManager.showToast( "Lỗi cập nhật: $e",isSuccess:false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}