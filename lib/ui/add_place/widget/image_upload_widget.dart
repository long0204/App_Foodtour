import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageUploadWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const MultiImageUploadWidget({super.key, required this.onImagesSelected});

  @override
  State<MultiImageUploadWidget> createState() => _MultiImageUploadWidgetState();
}

class _MultiImageUploadWidgetState extends State<MultiImageUploadWidget> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  final Color _bgColor = const Color(0xFFF5F1EA);
  final Color _cardColor = Colors.white;
  final Color _accentColor = const Color(0xFFE8C39F);

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((x) => File(x.path)));
      });
      widget.onImagesSelected(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(),
          Gap(15.h),
          _buildImagePickerRow(),
          Gap(12.h),
          Text(
            "Thêm hình ảnh quán ăn (tối đa 5)",
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13.sp,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.collections, color: _accentColor, size: 22.sp),
            Gap(10.w),
            Text("Hình Ảnh",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
          label: const Text("Chọn Hình Ảnh",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerRow() {
    return SizedBox(
      height: 70.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length + 1,
        itemBuilder: (context, index) {
          if (index < _images.length) {
            return _buildImagePreview(index);
          } else {
            return GestureDetector(
              onTap: _pickImages,
              child: _buildAddImageButton(),
            );
          }
        },
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Stack(
        children: [
          Container(
            width: 65.w,
            height: 65.w,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.grey[200]!, width: 2),
              image: DecorationImage(
                image: FileImage(_images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 2.h,
            right: 2.w,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.red, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      width: 65.w,
      height: 65.w,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: const Icon(Icons.add, color: Colors.grey),
    );
  }
}