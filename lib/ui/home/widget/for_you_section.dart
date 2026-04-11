import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../config/themes/text_style.dart';
import '../../../data/model/recommendation_result.dart';
import '../../../providers/recommendation_provider.dart';
import '../../../providers/community_provider.dart';
import '../../address/restaurant_detail_screen.dart';

/// Widget hiển thị "For You" section với personalized recommendations
class ForYouSection extends ConsumerWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationState = ref.watch(recommendationNotifierProvider);
    final allRestaurants = ref.watch(suggestionProvider);

    // Load recommendations khi có data
    if (allRestaurants.isNotEmpty && recommendationState.recommendations.isEmpty && !recommendationState.isLoading) {
      Future.microtask(() {
        ref.read(recommendationNotifierProvider.notifier).loadRecommendations(allRestaurants);
      });
    }

    if (recommendationState.isLoading) {
      return _buildLoadingState();
    }

    if (recommendationState.error != null) {
      return _buildErrorState(recommendationState.error!);
    }

    if (recommendationState.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dành cho bạn", style: k2d500.s16),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full recommendations screen
                },
                child: Text("Xem thêm", style: k2d400.s14.copyWith(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Gap(12.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: recommendationState.recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendationState.recommendations[index];
              return _RecommendationCard(
                recommendation: recommendation,
                onTap: () {
                  // Track view
                  ref.read(recommendationNotifierProvider.notifier).trackView(recommendation.restaurant);
                  
                  // Navigate to detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailScreen(
                        restaurant: recommendation.restaurant,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dành cho bạn", style: k2d500.s16),
          Gap(12.h),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dành cho bạn", style: k2d500.s16),
          Gap(12.h),
          Text(
            "Không thể tải gợi ý. Vui lòng thử lại sau.",
            style: k2d400.s14.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Card hiển thị từng recommendation
class _RecommendationCard extends StatelessWidget {
  final RecommendationResult recommendation;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final restaurant = recommendation.restaurant;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Image.network(
                    restaurant.imageUrls.isNotEmpty
                        ? restaurant.imageUrls.first
                        : 'https://via.placeholder.com/200',
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 140.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 40),
                      );
                    },
                  ),
                  // Tags
                  if (recommendation.tags.isNotEmpty)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getTagColor(recommendation.tags.first),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          _getTagLabel(recommendation.tags.first),
                          style: k2d500.s12.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  // Rating
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          Gap(4.w),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: k2d500.s12.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: k2d500.s14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(4.h),
                  Text(
                    restaurant.type,
                    style: k2d400.s12.copyWith(color: Colors.grey[600]),
                  ),
                  Gap(4.h),
                  Text(
                    restaurant.price,
                    style: k2d500.s12.copyWith(color: Colors.green),
                  ),
                  Gap(8.h),
                  // Reason
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      recommendation.reason,
                      style: k2d400.s11.copyWith(color: Colors.blue[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'trending':
        return Colors.red;
      case 'similar_to_favorites':
        return Colors.purple;
      case 'high_rated':
        return Colors.amber;
      case 'popular':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _getTagLabel(String tag) {
    switch (tag) {
      case 'trending':
        return '🔥 Hot';
      case 'similar_to_favorites':
        return '❤️ Yêu thích';
      case 'high_rated':
        return '⭐ Top';
      case 'popular':
        return '👥 Phổ biến';
      default:
        return '✨ Mới';
    }
  }
}
