import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../core/route.dart';
import '../../data/model/restaurant.dart';
import '../../providers/community_provider.dart';
import '../../providers/tab_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/shared/cached_image.dart';
import 'widgets/category_selector.dart';
final autoFocusSearchProvider = StateProvider<bool>((ref) => false);

class RestaurantListScreen extends ConsumerStatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  ConsumerState<RestaurantListScreen> createState() =>
      _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  String _searchQuery = "";
  String? _selectedCategory;
  Position? _userPosition;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await locationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userPosition = position;
        });
      }
    } catch (e) {
      debugPrint("Lỗi lấy GPS màn List: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(autoFocusSearchProvider, (previous, next) {
      if (next == true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _searchFocusNode.requestFocus();
          }
        });
        Future.microtask(() => ref.read(autoFocusSearchProvider.notifier).state = false);
      }
    });
    final restaurantsAsync = ref.watch(communityProvider);
    final Color _bgColor = const Color(0xFFF5F1EA);
    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.redAccent,
            expandedHeight: 80.h,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Danh sách quán ăn",
                  style: k2d500.s18.white

                ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 20.w, bottom: 15.h),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 15.h),
              child: Container(
                //height: 55.h,
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
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Tìm quán ăn, địa chỉ...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.redAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SliverCategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),
          SliverToBoxAdapter(child: Gap(15.h)),
          restaurantsAsync.when(
            data: (list) {
              final filteredList = list.where((res) {
                final matchCategory =
                    _selectedCategory == null || res.type == _selectedCategory;
                final matchSearch = _searchQuery.isEmpty ||
                    (res.name ?? "")
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    (res.address ?? "")
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                return matchCategory && matchSearch;
              }).toList();

              if (filteredList.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.shared.empty.image(
                          fit: BoxFit.contain,
                        ),
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
                      final restaurant = filteredList[index];
                      return RestaurantCardHorizontal(
                        restaurant: restaurant,
                        userPosition: _userPosition,
                      );
                    },
                    childCount: filteredList.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text("Lỗi: $err"))),
          ),
          SliverToBoxAdapter(child: Gap(100.h)),
        ],
      ),
    );
  }
}

class RestaurantCardHorizontal extends StatelessWidget {
  final Restaurant restaurant;
  final Position? userPosition;

  const RestaurantCardHorizontal(
      {super.key, required this.restaurant, this.userPosition});

  @override
  Widget build(BuildContext context) {
    String distanceStr = "";
    if (userPosition != null &&
        restaurant.latitude != null &&
        restaurant.longitude != null) {
      double dist = Geolocator.distanceBetween(userPosition!.latitude,
          userPosition!.longitude, restaurant.latitude!, restaurant.longitude!);
      if (dist < 1000) {
        distanceStr = " • ${dist.toStringAsFixed(0)}m";
      } else {
        distanceStr = " • ${(dist / 1000).toStringAsFixed(1)}km";
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () => push(detailRoute, extra: restaurant),
        child: Container(
          height: 110.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(15.r)),
                child: CachedImage(
                  restaurant.imageUrls.isNotEmpty
                      ? restaurant.imageUrls![0]
                      : '',
                  width: 110.h,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14.sp, color: Colors.grey),
                          Gap(4.w),
                          Expanded(
                            child: Text(
                              "${restaurant.address ?? ''}$distanceStr",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.price ?? '0',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 16),
                              Text(" ${restaurant.rating}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10.w),
            ],
          ),
        ),
      ),
    );
  }
}
