import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/route.dart';
import '../../../../data/model/restaurant.dart';
import '../../../../widgets/shared/cached_image.dart';
import '../providers/notifier.dart';

void showRestaurantQuickView(
    BuildContext context, WidgetRef ref, Restaurant res) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    builder: (context) => Container(
      padding: EdgeInsets.all(16.w),
      height: 200.h,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedImage(
                  res.imageUrls.isNotEmpty ? res.imageUrls.first : '',
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(res.name ?? "Đang cập nhật",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Gap(8.h),
                    Text(res.address ?? "Chưa có địa chỉ",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey)),
                    Gap(8.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        Text(" ${res.rating ?? 5.0}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    push(detailRoute, extra: res);
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
                  label: const Text("Chi tiết"),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Colors.blue)),
                ),
              ),
              Gap(12.w),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .read(foodMapNotifierProvider.notifier)
                        .startNavigation(res);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Bắt đầu"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h)),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
