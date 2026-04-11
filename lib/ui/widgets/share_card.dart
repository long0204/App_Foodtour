import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gap/gap.dart';
import '../../../config/themes/text_style.dart';
import '../../../data/model/restaurant.dart';

/// Widget để tạo share card đẹp cho restaurant
class RestaurantShareCard extends StatelessWidget {
  final Restaurant restaurant;
  final String? deepLink;

  const RestaurantShareCard({
    super.key,
    required this.restaurant,
    this.deepLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade600,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.white, size: 32.sp),
              Gap(12.w),
              Text(
                'FoodTour',
                style: k2d700.s24.copyWith(color: Colors.white),
              ),
            ],
          ),
          Gap(24.h),

          // Restaurant Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (restaurant.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.network(
                      restaurant.imageUrls.first,
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200.h,
                          color: Colors.grey[300],
                          child: Icon(Icons.restaurant, size: 60.sp),
                        );
                      },
                    ),
                  ),
                Gap(16.h),

                // Name
                Text(
                  restaurant.name,
                  style: k2d700.s20,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(8.h),

                // Type
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    restaurant.type,
                    style: k2d500.s14.copyWith(color: Colors.orange.shade800),
                  ),
                ),
                Gap(12.h),

                // Rating & Price
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20.sp),
                    Gap(4.w),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: k2d600.s16,
                    ),
                    Gap(16.w),
                    Icon(Icons.attach_money, color: Colors.green, size: 20.sp),
                    Text(
                      restaurant.price,
                      style: k2d600.s16.copyWith(color: Colors.green),
                    ),
                  ],
                ),
                Gap(12.h),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 18.sp),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        restaurant.address,
                        style: k2d400.s14.copyWith(color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(24.h),

          // QR Code & Call to Action
          if (deepLink != null)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: deepLink!,
                    version: QrVersions.auto,
                    size: 120.w,
                    backgroundColor: Colors.white,
                  ),
                  Gap(12.h),
                  Text(
                    'Quét mã để xem chi tiết',
                    style: k2d500.s14.copyWith(color: Colors.grey[800]),
                  ),
                ],
              ),
            ),

          if (deepLink == null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Tải FoodTour để khám phá thêm!',
                style: k2d600.s16.copyWith(color: Colors.orange.shade800),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact share card (nhỏ gọn hơn)
class CompactRestaurantShareCard extends StatelessWidget {
  final Restaurant restaurant;
  final String? deepLink;

  const CompactRestaurantShareCard({
    super.key,
    required this.restaurant,
    this.deepLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.orange, size: 24.sp),
                  Gap(8.w),
                  Text(
                    'FoodTour',
                    style: k2d700.s18.copyWith(color: Colors.orange),
                  ),
                ],
              ),
              if (deepLink != null)
                QrImageView(
                  data: deepLink!,
                  version: QrVersions.auto,
                  size: 60.w,
                  backgroundColor: Colors.white,
                ),
            ],
          ),
          Gap(16.h),

          // Restaurant info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (restaurant.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    restaurant.imageUrls.first,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100.w,
                        height: 100.w,
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant, size: 40.sp),
                      );
                    },
                  ),
                ),
              Gap(12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: k2d600.s16,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(6.h),
                    Text(
                      restaurant.type,
                      style: k2d400.s13.copyWith(color: Colors.grey[600]),
                    ),
                    Gap(6.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16.sp),
                        Gap(4.w),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: k2d500.s14,
                        ),
                        Gap(8.w),
                        Text(
                          restaurant.price,
                          style: k2d500.s14.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h),

          // Footer
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '🍽️ Khám phá thêm trên FoodTour',
                style: k2d500.s13.copyWith(color: Colors.orange.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
