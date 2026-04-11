import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/themes/text_style.dart';
import '../../../../core/route.dart';
import '../../../../data/model/restaurant.dart';

class RestaurantInfoSection extends StatelessWidget {
  final Restaurant restaurant;
  final double displayRating;
  final int reviewCount;

  const RestaurantInfoSection({
    super.key,
    required this.restaurant,
    required this.displayRating,
    required this.reviewCount,
  });

  Future<void> _openGoogleMaps(BuildContext context, String address) async {
    if (address.isEmpty) return;

    final query = Uri.encodeComponent(address);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không thể mở Google Maps")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    }
  }

  void _showMapOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Chọn ứng dụng bản đồ", style: k2d600.s18),
              Gap(16.h),
              ListTile(
                leading: const Icon(Icons.map_outlined, color: Colors.blue),
                title: Text("Xem trên bản đồ FoodTour", style: k2d600.s16),
                subtitle: Text("Xem vị trí quán trong ứng dụng", style: k2d500.s14.grey600ts),
                onTap: () { Navigator.pop(context); push(foodMapRoute); },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Colors.green),
                title: Text("Mở bằng Google Maps", style: k2d600.s16),
                subtitle: Text("Tìm đường đi bằng ứng dụng Google Map", style: k2d500.s14.grey600ts),
                onTap: () { Navigator.pop(context); _openGoogleMaps(context, "${restaurant.name} ${restaurant.address}"); },
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
    String ratingStr = displayRating.toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant.name ?? "", style: k2d600B.s24),
                Gap(12.h),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 18.sp, color: Colors.redAccent),
                    Gap(8.w),
                    Expanded(child: Text(restaurant.address ?? "", style: k2d500.s14.copyWith(color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis)),
                    Gap(12.w),
                    GestureDetector(
                      onTap: () => _showMapOptions(context),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                        child: Icon(Icons.map_rounded, color: Colors.blue, size: 22.sp),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.orange, size: 20.sp),
                          Gap(4.w),
                          Text(ratingStr, style: k2d600.s16.copyWith(color: Colors.orange[800])),
                          Text(" ($reviewCount Đánh giá)", style: k2d500.s14.copyWith(color: Colors.orange[800])),
                        ],
                      ),
                    ),
                    Text(restaurant.price ?? "0đ", style: k2d600.s18.copyWith(color: Colors.redAccent)),
                  ],
                ),
                Gap(24.h),
                Text("Về quán ăn này", style: k2d600.s18),
                Gap(8.h),
                Text(
                  (restaurant.description != null && restaurant.description!.isNotEmpty) ? restaurant.description! : "Chưa có mô tả cho quán này.",
                  style: k2d400.s14.copyWith(color: Colors.black87, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}