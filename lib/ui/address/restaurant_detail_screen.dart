import 'dart:ui';
import 'package:Foodtour/ui/address/providers/notifier.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../data/model/restaurant.dart';
import '../../widgets/shared/back_btn.dart';
import '../../widgets/shared/cached_image.dart';
import 'widgets/add_review_bottom_sheet.dart';
import 'widgets/restaurant_info_section.dart';
import 'widgets/review_card.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  int _currentImageIndex = 0;
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_listenScroll);
  }

  void _listenScroll() {
    if (!mounted) return;
    final position = _scrollController.position.pixels;
    final bool shouldShow = position > 200.h;

    if (_showTitle != shouldShow) setState(() => _showTitle = shouldShow);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAddReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReviewBottomSheet(
        restaurantId: widget.restaurant.id?? '',
        restaurantName: widget.restaurant.name ?? 'quán này',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(restaurantReviewsProvider(widget.restaurant.id?? ''));

    double displayRating = widget.restaurant.rating ?? 0.0;
    int reviewCount = 0;

    reviewsAsync.whenData((reviews) {
      reviewCount = reviews.length;
      if (reviews.isNotEmpty) {
        double sum = 0;
        for (var review in reviews) { sum += review.rating; }
        displayRating = sum / reviews.length;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            leading: MyBackButton(),
            expandedHeight: 300.h,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            pinned: true,
            title: _showTitle ? Text(widget.restaurant.name ?? "Chi tiết quán", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)) : null,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.restaurant.imageUrls.isNotEmpty)
                    CachedImage(widget.restaurant.imageUrls[0], height: double.infinity, width: double.infinity, fit: BoxFit.cover)
                  else
                    Assets.images.shared.placeholderImage.image(fit: BoxFit.cover),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(color: Colors.black.withOpacity(0.3), alignment: Alignment.center),
                    ),
                  ),
                  PageView.builder(
                    itemCount: widget.restaurant.imageUrls.isNotEmpty ? widget.restaurant.imageUrls.length : 1,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      return CachedImage(
                        widget.restaurant.imageUrls.isNotEmpty ? widget.restaurant.imageUrls[index] : '',
                        height: double.infinity, width: double.infinity, fit: BoxFit.contain,
                        errorWidget: Assets.images.shared.placeholderImage.image(fit: BoxFit.contain),
                        placeholder: Assets.images.shared.placeholderImage.image(fit: BoxFit.contain),
                      );
                    },
                  ),
                  if (widget.restaurant.imageUrls.length > 1)
                    Positioned(
                      bottom: 16.h, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.restaurant.imageUrls!.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: _currentImageIndex == index ? 20.w : 8.w, height: 8.h,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: _currentImageIndex == index ? Colors.redAccent : Colors.white54),
                          );
                        }),
                      ),
                    )
                ],
              ),
            ),
          ),

          // GỌI THÔNG TIN QUÁN
          SliverToBoxAdapter(
            child: RestaurantInfoSection(
              restaurant: widget.restaurant,
              displayRating: displayRating,
              reviewCount: reviewCount,
            ),
          ),

          // GỌI DANH SÁCH REVIEW (TỰ ĐỘNG XỬ LÝ STATE)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey[100], thickness: 8),
                Gap(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Đánh giá cộng đồng", style: k2d600.s18),
                      if (reviewCount > 0) Text("$reviewCount lượt", style: k2d500.s14.grey600ts),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                reviewsAsync.when(
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                  error: (error, stack) => Center(child: Text("Lỗi tải đánh giá: $error", style: TextStyle(color: Colors.red))),
                  data: (reviews) {
                    if (reviews.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.rate_review_outlined, size: 48.sp, color: Colors.grey[300]),
                              Gap(12.h),
                              Text("Chưa có đánh giá nào.\nHãy là người đầu tiên trải nghiệm!", textAlign: TextAlign.center, style: k2d400.s14.grey600ts),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: reviews.asMap().entries.map((entry) {
                          return FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: entry.key * 100),
                            child: ReviewCard(review: entry.value),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20.w, right: 20.w, top: 12.h,
          bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: Size(double.infinity, 54.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            elevation: 0,
          ),
          onPressed: _showAddReviewBottomSheet,
          icon: Icon(Icons.edit_note_rounded, color: Colors.white, size: 24.sp),
          label: Text("Viết đánh giá", style: k2d600.s16.white),
        ),
      ),
    );
  }
}