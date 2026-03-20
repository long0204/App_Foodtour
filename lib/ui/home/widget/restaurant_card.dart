import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCardHorizontal extends StatelessWidget {
  const RestaurantCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            child: Image.asset('asset/images/shared/empty.png',
                height: 150.h, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quán Bún Chả Ngon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                SizedBox(height: 4.h),
                Text("123 Quận 1, TP.HCM", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(" 4.5", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("30k - 50k", style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
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