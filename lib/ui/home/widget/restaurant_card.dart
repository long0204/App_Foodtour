import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../config/gen/assets.gen.dart';
import '../../../config/themes/text_style.dart';
import '../../../data/model/restaurant.dart';
import '../../../widgets/shared/cached_image.dart';

class RestaurantCardVertical extends StatelessWidget {
  final Restaurant restaurant;
  final Position? userPosition;

  const RestaurantCardVertical(
      {super.key, required this.restaurant, this.userPosition});

  @override
  Widget build(BuildContext context) {
    String distanceStr = "";
    if (userPosition != null &&
        restaurant.latitude != null &&
        restaurant.longitude != null) {
      double dist = Geolocator.distanceBetween(userPosition!.latitude,
          userPosition!.longitude, restaurant.latitude!, restaurant.longitude!);
      distanceStr = dist < 1000
          ? " • ${dist.toStringAsFixed(0)}m"
          : " • ${(dist / 1000).toStringAsFixed(1)}km";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: CachedImage(
              restaurant.imageUrls.isNotEmpty
                  ? restaurant.imageUrls![0]
                  : '',
              height: 130.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name ?? '',
                  style: k2d500.s14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        "${restaurant.address ?? ''}$distanceStr",
                        style: k2d400.s11.grey600ts,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        restaurant.price ?? '0',
                        style: k2d500.s12.red500ts
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        Text(" ${restaurant.rating}",
                            style: k2d400.s12 ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}