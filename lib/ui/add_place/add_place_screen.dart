import 'dart:io';
import 'package:Foodtour/ui/add_place/providers/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../config/themes/text_style.dart';
import '../../core/route.dart';
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

  List<File> _selectedImages = [];
  String? _selectedCategory;

  final Color _bgColor = const Color(0xFFF5F1EA);
  final Color _cardColor = Colors.white;
  final Color _iconColor = const Color(0xFFD17C7C);

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Bạn chỉ được tải lên tối đa 5 ảnh!")));
        return;
      }
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vui lòng chọn loại hình quán!")));
        return;
      }

      try {
        await ref.read(addPlaceNotifierProvider.notifier).submitPlace(
              name: _nameController.text.trim(),
              address: _addressController.text.trim(),
              price: _priceController.text.trim(),
              description: _descriptionController.text.trim(),
              type: _selectedCategory!,
              images: _selectedImages,
            );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thêm quán thành công!")));
        pushReplacement(rootRoute);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(addPlaceNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.redAccent,
              expandedHeight: 80.h,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Thêm Địa Điểm Mới", style: k2d500.s18.white),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 15.h),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  MultiImageUploadWidget(
                    onImagesSelected: (images) =>
                        setState(() => _selectedImages = images),
                  ),

                  Gap(15.h),

                  // FORM THÔNG TIN
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Tên Quán Ăn", Icons.house_rounded,
                            const Color(0xFF9CCC65)),
                        _buildTextField(_nameController, "Nhập tên quán..."),
                        Gap(15.h),
                        _buildInputLabel("Địa Chỉ Chính Xác", Icons.location_on,
                            Colors.redAccent),
                        _buildTextField(_addressController, "Nhập địa chỉ..."),
                        Gap(15.h),
                        _buildInputLabel("Loại Hình Quán",
                            Icons.restaurant_menu, Colors.blueAccent),
                        CategoryDropdown(
                          onCategorySelected: (cat) =>
                              setState(() => _selectedCategory = cat),
                        ),
                        Gap(15.h),
                        _buildInputLabel("Khoảng Giá (₫)",
                            Icons.payments_rounded, Colors.amber[700]!),
                        _buildTextField(
                            _priceController, "Ví dụ: 50.000 - 100.000...",
                            keyboardType: TextInputType.number),
                        Gap(15.h),
                        _buildInputLabel("Mô Tả Chi Tiết",
                            Icons.rate_review_rounded, _iconColor),
                        _buildTextField(_descriptionController,
                            "Chia sẻ cảm nhận của bạn về quán...",
                            isDescription: true),
                        Gap(10.h),
                      ],
                    ),
                  ),

                  Gap(25.h),

                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _submitData,
                      icon: isSubmitting
                          ? const SizedBox.shrink()
                          : const Icon(Icons.check_circle_outline,
                              color: Colors.white),
                      label: isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("Hoàn Tất Thêm Quán",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
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
          Text(text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isDescription = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: isDescription ? 6 : 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: _bgColor,
        contentPadding: EdgeInsets.symmetric(
            vertical: isDescription ? 15.h : 10.h, horizontal: 16.w),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Vui lòng nhập thông tin" : null,
    );
  }
}
