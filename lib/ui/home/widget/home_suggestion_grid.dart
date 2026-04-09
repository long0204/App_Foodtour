import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/route.dart';
import '../../../../providers/community_provider.dart';
import '../../../../widgets/shared/shimmer.dart';
import '../../../../widgets/base/base.dart';
import '../widget/restaurant_card.dart';

class HomeSuggestionGrid extends ConsumerWidget {
  const HomeSuggestionGrid({super.key});

  Widget _buildGridShimmer() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.65,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            ShimmerLoading(height: double.infinity, radius: 15.r),
        childCount: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionAsync = ref.watch(suggestionProvider);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: suggestionAsync.when(
        loading: () => _buildGridShimmer(),
        error: (err, stack) =>
            SliverToBoxAdapter(child: Center(child: Text("Lỗi: $err"))),
        data: (list) {
          final sortedList = List.of(list)
            ..sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));

          if (sortedList.isEmpty) {
            return const SliverToBoxAdapter(
                child: Center(child: Text("Không có địa điểm nào.")));
          }

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final restaurant = sortedList[index];
                return ZoomTap(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    push(detailRoute, extra: restaurant);
                  },
                  child: RestaurantCardVertical(restaurant: restaurant),
                );
              },
              childCount: sortedList.length,
            ),
          );
        },
      ),
    );
  }
}
