import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/themes/text_style.dart';
import '../providers/notifier.dart';

class AddReviewBottomSheet extends ConsumerStatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const AddReviewBottomSheet({super.key, required this.restaurantId, required this.restaurantName});

  @override
  ConsumerState<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends ConsumerState<AddReviewBottomSheet> {
  double _currentRating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  List<File> _selectedImages = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        int remainingSlots = 5 - _selectedImages.length;
        if (remainingSlots > 0) {
          _selectedImages.addAll(images.take(remainingSlots).map((xFile) => File(xFile.path)).toList());
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập bình luận")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      await ref.read(restaurantReviewsProvider(widget.restaurantId).notifier).addReview(
        rating: _currentRating,
        comment: _commentController.text.trim(),
        images: _selectedImages,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cảm ơn bạn đã đánh giá!")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        left: 20.w, right: 20.w, top: 12.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40.w, height: 5.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
          Gap(20.h),
          Text("Đánh giá trải nghiệm", style: k2d600.s20),
          Gap(8.h),
          Text("Chia sẻ cảm nhận của bạn về\n${widget.restaurantName}", style: k2d400.s14.grey600ts, textAlign: TextAlign.center),
          Gap(24.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _currentRating = index + 1.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(index < _currentRating ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber[500], size: 45.sp),
                ),
              );
            }),
          ),
          Gap(24.h),

          Container(
            decoration: BoxDecoration(color: const Color(0xFFF5F1EA), borderRadius: BorderRadius.circular(16.r)),
            child: TextField(
              controller: _commentController,
              maxLines: 4, style: k2d500.s14,
              decoration: InputDecoration(hintText: "Món ăn ngon, không gian đẹp...", hintStyle: k2d400.s14.grey600ts, contentPadding: EdgeInsets.all(16.w), border: InputBorder.none),
            ),
          ),
          Gap(20.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 10.w, runSpacing: 10.h,
                  children: _selectedImages.map((file) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12.r), child: Image.file(file, width: 70.w, height: 70.w, fit: BoxFit.cover)),
                        Positioned(
                          right: -5, top: -5,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImages.remove(file)),
                            child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54), padding: EdgeInsets.all(4.w), child: const Icon(Icons.close, color: Colors.white, size: 14)),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_selectedImages.length < 5)
                    TextButton.icon(onPressed: _pickImages, icon: Icon(Icons.add_a_photo_outlined, color: Colors.redAccent, size: 20.sp), label: Text("Thêm ảnh", style: k2d500.s14.copyWith(color: Colors.redAccent)))
                  else
                    Text("Đã đạt giới hạn 5 ảnh", style: k2d500.s14.copyWith(color: Colors.redAccent)),
                  if (_selectedImages.isNotEmpty) Text("Đã chọn: ${_selectedImages.length}/5", style: k2d500.s12.grey600ts),
                ],
              ),
            ],
          ),
          Gap(20.h),

          SizedBox(
            width: double.infinity, height: 55.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
              onPressed: _isUploading ? null : _submit,
              icon: Icon(Icons.send_rounded, size: 20.sp),
              label: _isUploading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("Gửi đánh giá", style: k2d600.s16.white),
            ),
          ),
        ],
      ),
    );
  }
}