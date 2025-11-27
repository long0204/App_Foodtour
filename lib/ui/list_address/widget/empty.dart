import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmptyRestaurantPlaceholder extends StatelessWidget {
  const EmptyRestaurantPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('asset/images/shared/empty.png',
              height: 120.h, width: 160.w),
          const Gap(12),
          const Text(
            'Không tìm thấy quán nào',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 14,
              letterSpacing: -0.05,
            ),
          ),
        ],
      ),
    );
  }
}
