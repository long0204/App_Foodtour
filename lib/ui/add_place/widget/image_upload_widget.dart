import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(File) onImageSelected; // Thêm dòng này

  const ImageUploadWidget({super.key, required this.onImageSelected});

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _image = image);
      widget.onImageSelected(File(image.path)); // Gửi file ra ngoài
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: _image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 40.sp, color: Colors.grey),
            const Text("Thêm ảnh quán ăn"),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(File(_image!.path), fit: BoxFit.cover, width: double.infinity),
        ),
      ),
    );
  }
}