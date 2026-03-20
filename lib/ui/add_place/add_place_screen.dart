import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Sửa import này
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/route.dart';
import '../../data/model/restaurant.dart';
import '../../providers/community_provider.dart';
import '../../services/cloudinary_service.dart';
import '../../services/image_service.dart';
import 'widget/category_dropdown.dart';
import 'widget/image_upload_widget.dart';

// Đổi sang ConsumerStatefulWidget để dùng 'ref'
class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ImageService _imageService = ImageService();
  // Thêm biến để hứng ảnh từ widget con
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chia sẻ quán ăn")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Truyền callback để lấy ảnh khi người dùng chọn xong
            ImageUploadWidget(
              onImageSelected: (file) {
                setState(() {
                  _selectedImage = file;
                });
              },
            ),

            SizedBox(height: 20.h),
            TextFormField(
              controller: _nameController, // Gán controller
              decoration: const InputDecoration(labelText: "Tên quán ăn", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Vui lòng nhập tên quán" : null,
            ),

            SizedBox(height: 16.h),
            TextFormField(
              controller: _addressController, // Gán controller
              decoration: const InputDecoration(
                  labelText: "Địa chỉ cụ thể",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on)
              ),
              validator: (v) => v!.isEmpty ? "Vui lòng nhập địa chỉ" : null,
            ),

            SizedBox(height: 16.h),
            const CategoryDropdown(),

            SizedBox(height: 30.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
              ),
              onPressed: _submitData,
              child: Text("Đăng bài ngay", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            )
          ],
        ),
      ),
    );
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn ảnh món ăn!")),
        );
        return;
      }

      // 1. Hiển thị Loading
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator())
      );

      try {
        final File? compressedImage = await _imageService.compressImage(_selectedImage!);
        final File fileToUpload = compressedImage ?? _selectedImage!;

        final String? imageUrl = await cloudinaryService.uploadImage(fileToUpload);

        if (imageUrl != null) {
          final newRes = Restaurant(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text,
            address: _addressController.text,
            type: "Ăn vặt",
            price: "30.000đ",
            rating: 5.0,
            imageUrls: [imageUrl],
          );

          await ref.read(communityProvider.notifier).uploadNewRestaurant(newRes);

          if (!mounted) return;
          popUtil();

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đăng bài thành công!"))
          );
        }
      } catch (e) {
        if (!mounted) return;

       pop();

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Có lỗi xảy ra: ${e.toString()}"))
        );
      }
    }
  }
}