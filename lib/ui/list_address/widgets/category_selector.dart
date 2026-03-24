// File: lib/ui/list_address/widget/category_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/community_provider.dart';

class SliverCategorySelector extends ConsumerWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const SliverCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final Map<String, String> categoryIcons = const {
    "Bánh": "🍰", "Coffee": "☕", "Lẩu": "🥘", "Bún": "🍜", "Chay": "🥗",
    "Chè": "🍧", "Gà": "🍗", "Nem": "🌯", "Nướng": "🍢", "Ốc": "🐚",
    "Trà sữa": "🧋", "Vịt": "🦆", "Cơm": "🍚",
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(communityProvider);

    return restaurantsAsync.when(
      data: (list) {
        final categories = list.map((res) => res.type ?? "").where((t) => t.isNotEmpty).toSet().toList();
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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                  ),
                  avatar: category != null
                      ? Text(categoryIcons[category] ?? "🍽️", style: TextStyle(fontSize: 16.sp))
                      : null,
                  selected: isSelected,
                  onSelected: (selected) {
                    onCategorySelected(selected ? category : null);
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
                      color: isSelected ? Colors.redAccent : Colors.grey[200]!,
                    ),
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