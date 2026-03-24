import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../core/route.dart';
import '../../providers/community_provider.dart';
import '../home/widget/category_selector.dart';
import 'community_list_screen.dart'; // Để tái sử dụng RestaurantCardVertical

class RestaurantListScreen extends ConsumerStatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  ConsumerState<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(communityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Khám phá quán ăn",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 1. Thanh tìm kiếm toàn cục
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Tìm quán ăn, địa chỉ...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Phần danh mục chuyển từ HomeScreen sang
                  const CategorySelector(),

                  Gap(12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text("Tất cả quán ăn",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ),

                  Gap(12.h),

                  // 3. Danh sách tất cả quán ăn
                  restaurantsAsync.when(
                    data: (list) {
                      final filteredList = list.where((res) =>
                      (res.name ?? "").toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          (res.address ?? "").toLowerCase().contains(_searchQuery.toLowerCase())
                      ).toList();

                      if (filteredList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Không có quán ăn nào."),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final restaurant = filteredList[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: GestureDetector(
                              onTap: () => push(detailRoute, extra: restaurant),
                              child: RestaurantCardVertical(restaurant: restaurant),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text("Lỗi: $err")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}