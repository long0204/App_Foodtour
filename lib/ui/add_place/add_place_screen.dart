import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  final TextEditingController _descriptionController = TextEditingController();

  final ImageService _imageService = ImageService();
  List<File> _selectedImages = [];
  String? _selectedCategory;

  final Color _bgColor = const Color(0xFFF5F1EA);
  final Color _cardColor = Colors.white;
  final Color _accentColor = const Color(0xFFE8C39F);
  final Color _iconColor = const Color(0xFFD17C7C);

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ít nhất một ảnh!")));
        return;
      }
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn loại hình quán!")));
        return;
      }

      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

      try {
        List<File> compressedFiles = [];
        for (final file in _selectedImages) {
          final compressed = await _imageService.compressImage(file);
          compressedFiles.add(compressed ?? file);
        }

        final imageUrls = await Future.wait(compressedFiles.map((file) => cloudinaryService.uploadImage(file)));
        final finalImageUrls = imageUrls.whereType<String>().toList();

        if (finalImageUrls.isNotEmpty) {
          final coords = await getCoordinatesFromAddress(_addressController.text);

          final newDocRef = FirebaseFirestore.instance.collection('restaurants').doc();
          final newRes = Restaurant(
            id: newDocRef.id,
            name: _nameController.text,
            address: _addressController.text,
            type: _selectedCategory!,
            price: _priceController.text,
            rating: 5.0,
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
          _descriptionController.clear();
          setState(() {
            _selectedImages = [];
            _selectedCategory = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng bài thành công!")));
          pushReplacement(rootRoute);
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 80.h,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Thêm Địa Điểm Mới",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 15.h),
              ),
            ),
            // SliverAppBar(
            //   backgroundColor: _bgColor,
            //   expandedHeight: 120.h,
            //   pinned: true,
            //   elevation: 0,
            //   flexibleSpace: FlexibleSpaceBar(
            //     titlePadding: EdgeInsets.only(left: 20.w, bottom: 15.h),
            //     title: Container(
            //       padding: EdgeInsets.all(10.w),
            //       decoration: BoxDecoration(
            //         color: _cardColor,
            //         borderRadius: BorderRadius.circular(15.r),
            //         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            //       ),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Text("Thêm Địa Điểm Mới",
            //               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
            //           Gap(10.w),
            //           Icon(Icons.add_home_outlined, color: _iconColor, size: 22.sp),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  MultiImageUploadWidget(
                    onImagesSelected: (images) => setState(() => _selectedImages = images),
                  ),

                  Gap(15.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Tên Quán Ăn", Icons.house_rounded, const Color(0xFF9CCC65)),
                        _buildTextField(_nameController, "Nhập tên quán..."),
                        Gap(15.h),

                        _buildInputLabel("Địa Chỉ Chính Xác", Icons.location_on, Colors.redAccent),
                        _buildTextField(_addressController, "Nhập địa chỉ..."),
                        Gap(15.h),

                        _buildInputLabel("Loại Hình Quán", Icons.restaurant_menu, Colors.blueAccent),
                        CategoryDropdown(
                          onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                        ),
                        Gap(15.h),

                        _buildInputLabel("Khoảng Giá (₫)", Icons.payments_rounded, Colors.amber[700]!),
                        _buildTextField(_priceController, "Ví dụ: 50.000 - 100.000...", keyboardType: TextInputType.number),
                        Gap(15.h),

                        _buildInputLabel("Mô Tả Chi Tiết", Icons.rate_review_rounded, _iconColor),
                        _buildTextField(_descriptionController, "Chia sẻ cảm nhận của bạn về quán...", isDescription: true),
                        Gap(10.h),
                      ],
                    ),
                  ),

                  Gap(25.h),

                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton.icon(
                      onPressed: _submitData,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text("Hoàn Tất Thêm Quán", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                        elevation: 4,
                      ),
                    ),
                  ),

                  Gap(50.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22.sp),
          Gap(10.w),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isDescription = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: isDescription ? 6 : 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: _bgColor,
        contentPadding: EdgeInsets.symmetric(vertical: isDescription ? 15.h : 10.h, horizontal: 16.w),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Vui lòng nhập thông tin" : null,
    );
  }
}