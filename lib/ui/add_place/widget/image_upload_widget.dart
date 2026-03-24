// File: lib/presentation/add_place/widget/image_upload_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// ĐỔI TÊN LỚP VÀ CALLBACK CỦA BẠN
class MultiImageUploadWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected; // CALLBACK MỚI: Trả về một danh sách

  const MultiImageUploadWidget({super.key, required this.onImagesSelected});

  @override
  State<MultiImageUploadWidget> createState() => _MultiImageUploadWidgetState();
}

class _MultiImageUploadWidgetState extends State<MultiImageUploadWidget> {
  // SỬ DỤNG DANH SÁCH ẢNH
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker(); // Sử dụng ImagePicker trực tiếp

  Future<void> _pickImages() async {
    // SỬ DỤNG HÀM pickMultiImage ĐỂ CHỌN NHIỀU ẢNH
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        // Thêm các ảnh mới được chọn vào danh sách
        _images.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
      // Gọi callback để cập nhật danh sách ảnh ra ngoài màn hình chính
      widget.onImagesSelected(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    // Gọi callback để cập nhật danh sách ảnh ra ngoài màn hình chính
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    // Giao diện là một ListView nằm ngang
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length + 1, // +1 là nút "Thêm ảnh"
        itemBuilder: (context, index) {
          if (index == 0) {
            // Nút "Thêm ảnh"
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: Colors.grey[600], size: 32.sp),
                      SizedBox(height: 4.h),
                      Text("Thêm ảnh", style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
                      Text("(${_images.length}/5)", style: TextStyle(color: Colors.grey[600], fontSize: 10.sp)),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Hiển thị một ảnh
            final int imageIndex = index - 1; // Chỉ số chính xác trong danh sách _images
            final file = _images[imageIndex];
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => _removeImage(imageIndex),
                      child: Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.close, color: Colors.red, size: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}