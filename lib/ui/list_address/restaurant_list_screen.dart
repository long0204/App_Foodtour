import 'package:Foodtour/ui/list_address/providers/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../providers/community_provider.dart';
import 'widgets/category_selector.dart';
import 'widgets/restaurant_card_horizontal.dart';

final autoFocusSearchProvider = StateProvider<bool>((ref) => false);

class RestaurantListScreen extends ConsumerStatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  ConsumerState<RestaurantListScreen> createState() =>
      _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(autoFocusSearchProvider, (previous, next) {
      if (next == true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _searchFocusNode.requestFocus();
        });
        Future.microtask(
            () => ref.read(autoFocusSearchProvider.notifier).state = false);
      }
    });

    final restaurantsAsync = ref.watch(communityProvider);
    final listState = ref.watch(restaurantListNotifierProvider);

    final Color bgColor = const Color(0xFFF5F1EA);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // APP BAR
          SliverAppBar(
            backgroundColor: Colors.redAccent,
            expandedHeight: 80.h,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Danh sách quán ăn", style: k2d500.s18.white),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 20.w, bottom: 15.h),
            ),
          ),

          // SEARCH BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 15.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ],
                ),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onChanged: (value) => ref
                      .read(restaurantListNotifierProvider.notifier)
                      .updateSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: "Tìm quán ăn, địa chỉ...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.redAccent),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ),
          ),

          // CATEGORY SELECTOR
          const SliverToBoxAdapter(
            child: SliverCategorySelector(),
          ),
          SliverToBoxAdapter(child: Gap(15.h)),

          // DANH SÁCH QUÁN SAU KHI LỌC
          restaurantsAsync.when(
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text("Lỗi: $err"))),
            data: (list) {
              final filteredList = list.where((res) {
                final matchCategory = listState.selectedCategory == null ||
                    res.type == listState.selectedCategory;
                final matchSearch = listState.searchQuery.isEmpty ||
                    (res.name ?? "")
                        .toLowerCase()
                        .contains(listState.searchQuery.toLowerCase()) ||
                    (res.address ?? "")
                        .toLowerCase()
                        .contains(listState.searchQuery.toLowerCase());
                return matchCategory && matchSearch;
              }).toList();

              if (filteredList.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.shared.empty.image(fit: BoxFit.contain),
                        Gap(15.h),
                        const Text("Không tìm thấy quán ăn phù hợp.",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return RestaurantCardHorizontal(
                        restaurant: filteredList[index],
                        userPosition: listState.userPosition,
                      );
                    },
                    childCount: filteredList.length,
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: Gap(100.h)),
        ],
      ),
    );
  }
}
