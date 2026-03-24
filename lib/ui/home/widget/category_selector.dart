import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/route.dart';
import '../../list_address/community_list_screen.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "Bánh", "icon": Icons.cake_outlined},
    {"name": "Coffee", "icon": Icons.coffee_outlined},
    {"name": "Lẩu", "icon": Icons.fastfood},
    {"name": "Bún", "icon": Icons.icecream_outlined},
    {"name": "Chay", "icon": Icons.icecream_outlined},
    {"name": "Chè", "icon": Icons.icecream_outlined},
    {"name": "Gà", "icon": Icons.icecream_outlined},
    {"name": "Nem", "icon": Icons.icecream_outlined},
    {"name": "Nướng", "icon": Icons.icecream_outlined},
    {"name": "Ốc", "icon": Icons.icecream_outlined},
    {"name": "Trà sữa", "icon": Icons.icecream_outlined},
    {"name": "Vịt", "icon": Icons.icecream_outlined},
    {"name": "Cơm", "icon": Icons.rice_bowl_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text("Danh mục", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 16.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  push(communityListRoute, extra: category['name']);

                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: Colors.red.shade50,
                        child: Icon(category['icon'], color: Colors.redAccent),
                      ),
                      SizedBox(height: 8.h),
                      Text(category['name'], style: TextStyle(fontSize: 12.sp)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}