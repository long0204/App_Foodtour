// File: lib/presentation/add_place/add_place_screen.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/route.dart';
import '../../data/model/restaurant.dart';
import '../../data/sources/remote/google_service.dart';
import '../../providers/community_provider.dart';
import '../../services/cloudinary_service.dart';
import '../../services/image_service.dart';
import 'widget/category_dropdown.dart';
import 'widget/image_upload_widget.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImageService _imageService = ImageService();
  List<File> _selectedImages = [];
  String? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chia sẻ địa điểm",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            MultiImageUploadWidget(
              onImagesSelected: (files) {
                setState(() {
                  _selectedImages = files;
                });
              },
            ),

            SizedBox(height: 20.h),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên quán ăn", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Vui lòng nhập tên quán" : null,
            ),

            SizedBox(height: 16.h),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                  labelText: "Địa chỉ cụ thể",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on)
              ),
              validator: (v) => v!.isEmpty ? "Vui lòng nhập địa chỉ" : null,
            ),

            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Giá (VD: 30k-50k)", border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? "Vui lòng nhập giá" : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextFormField(
                    controller: _ratingController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Đánh giá (1.0 - 5.0)", border: OutlineInputBorder()),
                    validator: (v) {
                      if (v!.isEmpty) return "Nhập điểm";
                      final rating = double.tryParse(v);
                      if (rating == null || rating < 1.0 || rating > 5.0) {
                        return "Từ 1.0 đến 5.0";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),
            CategoryDropdown(
              onCategorySelected: (category) {
                _selectedCategory = category;
              },
            ),

            SizedBox(height: 16.h),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Mô tả quán (tùy chọn)", border: OutlineInputBorder(), alignLabelWithHint: true),
            ),

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
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn ít nhất một ảnh món ăn!")),
        );
        return;
      }

      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn loại hình quán!")),
        );
        return;
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator())
      );

      try {
        List<File> compressedFiles = [];
        for (final file in _selectedImages) {
          final compressedFile = await _imageService.compressImage(file);
          compressedFiles.add(compressedFile ?? file);
        }

        final List<String?> imageUrls = await Future.wait(
            compressedFiles.map((file) => cloudinaryService.uploadImage(file))
        );

        final List<String> finalImageUrls = imageUrls.whereType<String>().toList();

        if (finalImageUrls.length < compressedFiles.length) {
          throw Exception("Có lỗi xảy ra khi tải ảnh lên Cloudinary!");
        }

        if (finalImageUrls.isNotEmpty) {
          final newDocRef = FirebaseFirestore.instance.collection('restaurants').doc();

          final coords = await getCoordinatesFromAddress(_addressController.text);

          final newRes = Restaurant(
            id: newDocRef.id,
            name: _nameController.text,
            address: _addressController.text,
            type: _selectedCategory!,
            price: _priceController.text,
            rating: double.parse(_ratingController.text),
            imageUrls: finalImageUrls,
            description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
            latitude: coords?.latitude,
            longitude: coords?.longitude,
          );

          await ref.read(communityProvider.notifier).uploadNewRestaurant(newRes);

          if (!mounted) return;
          Navigator.of(context).pop();

          _nameController.clear();
          _addressController.clear();
          _priceController.clear();
          _ratingController.clear();
          _descriptionController.clear();
          setState(() {
            _selectedImages = [];
            _selectedCategory = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đăng bài thành công!"))
          );

          pushReplacement(rootRoute);
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Có lỗi xảy ra: ${e.toString()}"))
        );
      }
    }
  }
}