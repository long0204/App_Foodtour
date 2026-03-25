import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../data/model/restaurant.dart';
import '../../core/route.dart';
import '../../data/model/review.dart';
import '../../providers/community_provider.dart';
import '../../widgets/shared/back_btn.dart';
import '../../widgets/shared/cached_image.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  int _currentImageIndex = 0;
  List<Review> _localReviews = [];

  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _localReviews = widget.restaurant.reviews ?? [];

    _scrollController = ScrollController();
    _scrollController.addListener(_listenScroll);
  }

  void _listenScroll() {
    if (!mounted) return;
    final position = _scrollController.position.pixels;
    final bool shouldShow = position > 200.h;

    if (_showTitle != shouldShow) {
      setState(() {
        _showTitle = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openGoogleMaps(String address) async {
    if (address.isEmpty) return;
    final query = Uri.encodeComponent(address);
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không thể mở Google Maps")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${e.toString()}")),
        );
      }
    }
  }

  void _showMapOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chọn ứng dụng bản đồ",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Gap(16.h),
              ListTile(
                leading: const Icon(Icons.map_outlined, color: Colors.blue),
                title: const Text("Xem trên bản đồ FoodTour"),
                subtitle: const Text("Xem vị trí quán trong ứng dụng"),
                onTap: () {
                  pop();
                  push(foodMapRoute);
                },
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                title: const Text("Mở bằng Google Maps"),
                subtitle: const Text("Tìm đường đi bằng ứng dụng ngoài"),
                onTap: () {
                  Navigator.pop(context);
                  _openGoogleMaps(
                      "${widget.restaurant.name} ${widget.restaurant.address}");
                },
              ),
              Gap(10.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double displayRating = widget.restaurant.rating ?? 0.0;

    if (_localReviews.isNotEmpty) {
      double sum = 0;
      for (var review in _localReviews) {
        sum += review.rating;
      }
      displayRating = sum / _localReviews.length;
    }
    String ratingStr = displayRating.toStringAsFixed(1);

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
            title: _showTitle
                ? Text(widget.restaurant.name ?? "Chi tiết quán",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))
                : null,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.restaurant.imageUrls.isNotEmpty)
                    CachedImage(
                      widget.restaurant.imageUrls[0],
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else
                    Assets.images.shared.placeholderImage
                        .image(fit: BoxFit.cover),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  PageView.builder(
                    itemCount: widget.restaurant.imageUrls.isNotEmpty
                        ? widget.restaurant.imageUrls.length
                        : 1,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CachedImage(
                        widget.restaurant.imageUrls.isNotEmpty
                            ? widget.restaurant.imageUrls[index]
                            : '',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorWidget: Assets.images.shared.placeholderImage
                            .image(fit: BoxFit.contain),
                        placeholder: Assets.images.shared.placeholderImage
                            .image(fit: BoxFit.contain),
                      );
                    },
                  ),
                  if (widget.restaurant.imageUrls.length > 1)
                    Positioned(
                      bottom: 16.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            widget.restaurant.imageUrls!.length, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.redAccent
                                  : Colors.white54,
                            ),
                          );
                        }),
                      ),
                    )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                        Gap(8.h),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16.sp, color: Colors.black54),
                            Gap(4.w),
                            Expanded(
                              child: Text(
                                widget.restaurant.address ?? "",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13.sp),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gap(8.w),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.all(6.w),
                                constraints: const BoxConstraints(),
                                icon: Icon(Icons.map,
                                    color: Colors.blue, size: 20.sp),
                                onPressed: () => _showMapOptions(context),
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 20.sp),
                                  Text(
                                    " $ratingStr",
                                    style: k2d600.s16,
                                  ),
                                  Flexible(
                                    child: Text(
                                      " (${_localReviews.length} Đánh giá)",
                                      style: k2d600.s12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.restaurant.price ?? "0đ",
                              style:
                                  k2d600.s16.copyWith(color: Colors.redAccent),
                            ),
                          ],
                        ),
                        Gap(16.h),
                        Divider(color: Colors.grey[200], thickness: 1),
                        Gap(8.h),
                        Text(
                          "Mô tả",
                          style: k2d600.s16,
                        ),
                        Gap(8.h),
                        Text(
                            (widget.restaurant.description != null &&
                                    widget.restaurant.description!.isNotEmpty)
                                ? widget.restaurant.description!
                                : "Chưa có mô tả cho quán này.",
                            style: k2d500.s14
                            // TextStyle(
                            //     color: Colors.black87,
                            //     fontSize: 14.sp,
                            //     height: 1.5),
                            ),
                        Gap(24.h),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lời Đánh giá",
                          style: k2d500.s16,
                        ),
                        SizedBox(height: 12.h),
                        if (_localReviews.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                                child: Text(
                                    "Chưa có đánh giá nào. Hãy là người đầu tiên!",
                                    style: k2d400.copyWith(
                                        fontStyle: FontStyle.italic))),
                          )
                        else
                          ..._localReviews
                              .map((review) => _buildReviewCard(review))
                              .toList(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r)),
            ),
            onPressed: () {
              _showAddReviewBottomSheet(context);
            },
            child: Text(
              "Rate & Review",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    final difference = DateTime.now().difference(review.createdAt);
    String timeAgo = difference.inDays > 0
        ? "${difference.inDays} ngày trước"
        : (difference.inHours > 0
            ? "${difference.inHours} giờ trước"
            : "Vừa xong");

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: (review.reviewImageUrl != null &&
                    review.reviewImageUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(review.reviewImageUrl!)
                    as ImageProvider
                : Assets.images.user.avtDefault.provider(),
            backgroundColor: Colors.grey[300],
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint("Lỗi load avatar: $exception");
            },
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 16.sp,
                    );
                  }),
                ),
                SizedBox(height: 8.h),
                Text(
                  review.comment,
                  style: TextStyle(color: Colors.black87, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReviewBottomSheet(BuildContext context) {
    double currentRating = 5.0;
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.w,
                right: 16.w,
                top: 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Đánh giá quán",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 36.sp,
                        ),
                        onPressed: () {
                          setModalState(() {
                            currentRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Nhập cảm nhận của bạn về quán...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () async {
                        if (commentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Vui lòng nhập bình luận")));
                          return;
                        }

                        if (widget.restaurant.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Lỗi: Không tìm thấy ID quán")));
                          return;
                        }

                        final reviewId = FirebaseFirestore.instance
                            .collection('dummy')
                            .doc()
                            .id;

                        final currentUser = FirebaseAuth.instance.currentUser;

                        final newReview = Review(
                          id: reviewId,
                          userId: currentUser!.uid, // ĐÂY LÀ TRƯỜNG QUAN TRỌNG ĐỂ BIẾT AI ĐÃ ĐÁNH GIÁ
                          userName: currentUser.displayName ?? "Ẩn danh",
                          rating: currentRating,
                          comment: commentController.text,
                          createdAt: DateTime.now(),
                        );

                        try {
                          await ref
                              .read(communityProvider.notifier)
                              .addReview(widget.restaurant.id!, newReview);

                          if (!context.mounted) return;
                          Navigator.pop(context);

                          setState(() {
                            _localReviews.insert(0, newReview);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Gửi đánh giá thành công!")));
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                        }
                      },
                      child: Text("Gửi đánh giá",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
