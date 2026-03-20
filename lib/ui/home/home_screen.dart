import 'package:Foodtour/ui/home/providers/notifier.dart';
import 'package:Foodtour/ui/home/widget/category_selector.dart';
import 'package:Foodtour/ui/home/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';

import '../../core/route.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodTour", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpinWheelBanner(context),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text("Quán ngon hôm nay", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),

            SizedBox(
              height: 280.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16.w),
                itemCount: 5,
                itemBuilder: (context, index) => const RestaurantCardHorizontal(),
              ),
            ),

            const CategorySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinWheelBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.redAccent, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bạn chưa biết ăn gì?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text("Thử ngay vòng quay may mắn!", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => push(spinRoute),
            child: const Text("Xoay ngay"),
          )
        ],
      ),
    );
  }
}