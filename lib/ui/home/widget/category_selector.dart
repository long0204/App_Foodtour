import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "Ăn sáng", "icon": Icons.wb_sunny_outlined},
    {"name": "Cà phê", "icon": Icons.coffee_outlined},
    {"name": "Lẩu", "icon": Icons.ramen_dining_outlined},
    {"name": "Ăn vặt", "icon": Icons.icecream_outlined},
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
              return Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: Colors.red.shade50,
                      child: Icon(categories[index]['icon'], color: Colors.redAccent),
                    ),
                    SizedBox(height: 8.h),
                    Text(categories[index]['name'], style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}