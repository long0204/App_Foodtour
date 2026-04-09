import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../config/themes/text_style.dart';
import '../../../../core/route.dart';
import '../../../../data/model/restaurant.dart';
import '../../../../widgets/shared/cached_image.dart';

class RestaurantCardHorizontal extends StatelessWidget {
  final Restaurant restaurant;
  final Position? userPosition;

  const RestaurantCardHorizontal(
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

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          push(detailRoute, extra: restaurant);
        },
        child: Container(
          height: 110.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(15.r)),
                child: CachedImage(
                  restaurant.imageUrls.isNotEmpty
                      ? restaurant.imageUrls![0]
                      : '',
                  width: 110.h,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14.sp, color: Colors.grey),
                          Gap(4.w),
                          Expanded(
                            child: Text(
                              "${restaurant.address ?? ''}$distanceStr",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.price ?? 'Đang cập nhật',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 16),
                              Text(" ${restaurant.rating}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10.w),
            ],
          ),
        ),
      ),
    );
  }
}
