import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/community_provider.dart';
import '../providers/notifier.dart';

class SliverCategorySelector extends ConsumerWidget {
  const SliverCategorySelector({super.key});

  static const Map<String, String> categoryIcons = {
    "Bánh": "🍰",
    "Coffee": "☕",
    "Lẩu": "🥘",
    "Bún": "🍜",
    "Chay": "🥗",
    "Chè": "🍧",
    "Gà": "🍗",
    "Nem": "🌯",
    "Nướng": "🍢",
    "Ốc": "🐚",
    "Trà sữa": "🧋",
    "Vịt": "🦆",
    "Cơm": "🍚",
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(communityProvider);
    // Lắng nghe state để biết danh mục nào đang được chọn
    final selectedCategory =
        ref.watch(restaurantListNotifierProvider).selectedCategory;

    return restaurantsAsync.when(
      data: (list) {
        final categories = list
            .map((res) => res.type ?? "")
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList();
        categories.sort();

        final List<String?> finalCategories = [null, ...categories];

        return SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: finalCategories.length,
            itemBuilder: (context, index) {
              final category = finalCategories[index];
              final isSelected = category == selectedCategory;

              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: FilterChip(
                  label: Text(
                    category ?? "Tất cả",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                  ),
                  avatar: category != null
                      ? Text(categoryIcons[category] ?? "🍽️",
                          style: TextStyle(fontSize: 16.sp))
                      : null,
                  selected: isSelected,
                  onSelected: (selected) {
                    ref
                        .read(restaurantListNotifierProvider.notifier)
                        .updateCategory(selected ? category : null);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.redAccent,
                  checkmarkColor: Colors.white,
                  elevation: 2,
                  pressElevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                        color:
                            isSelected ? Colors.redAccent : Colors.grey[200]!),
                  ),
                  showCheckmark: false,
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
