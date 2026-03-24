// File: lib/ui/home/home_screen.dart

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/route.dart';
import '../../providers/community_provider.dart';
import '../../providers/tab_provider.dart';
import '../../services/location_service.dart';
// import '../address/restaurant_detail_screen.dart'; // KHÔNG dùng màn hình detail ở đây
import '../address/restaurant_detail_screen.dart';
import '../spinWheel/SpinWheelScreen.dart';
import 'widget/restaurant_card.dart'; // SỬ DỤNG RestaurantCard cho danh sách

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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
      debugPrint("Lỗi lấy GPS màn Home: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(communityProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.h,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://www.celebritycruises.com/blog/content/uploads/2022/04/best-food-in-vietnam-hero.jpg',
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60.h,
                    left: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Xin chào bạn,",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.normal)),
                        Text("FoodTour hôm nay ăn gì?",
                            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm quán ăn, món ăn...",
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 0.h, bottom: 20.h),
          //     child: SizedBox(
          //       height: 200.h, // Đặt chiều cao phù hợp cho vòng quay
          //       child: const SpinWheelScreen(),
          //     ),
          //   ),
          // ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Địa điểm gần bạn", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  Gap(12.h),
                  GestureDetector(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = 1;
                    },
                    child: Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: (_userPosition == null)
                            ? const Center(child: Text("Đang lấy vị trí...", style: TextStyle(color: Colors.grey)))
                            : FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.dinos.foodtour',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                                  width: 40, height: 40,
                                  child: const Icon(Icons.person_pin_circle_sharp, color: Colors.blue, size: 25),
                                ),
                                ...restaurantsAsync.maybeWhen(
                                  data: (list) {
                                    final hasLatLng = list.where((r) => r.latitude != null && r.longitude != null);
                                    return hasLatLng.take(3).map((res) {
                                      return Marker(
                                        point: LatLng(res.latitude!, res.longitude!),
                                        width: 30, height: 30,
                                        child: const Icon(Icons.location_on, color: Colors.red, size: 20),
                                      );
                                    }).toList();
                                  },
                                  orElse: () => [],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Text("Đề xuất cho bạn", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: restaurantsAsync.when(
              data: (list) {
                list.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));

                if (list.isEmpty) {
                  return const SliverToBoxAdapter(child: Center(child: Text("Không có địa điểm nào.")));
                }

                // Tìm đến phần SliverGrid trong file home_screen.dart và sửa như sau:
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final restaurant = list[index];
                      return GestureDetector(
                        onTap: () {
                          push(detailRoute, extra: restaurant); // Chỉ mở Detail khi ấn vào
                        },
                        child: RestaurantDetailScreen(restaurant: restaurant),
                      );
                    },
                    childCount: list.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text("Lỗi: $err"))),
            ),
          ),

          SliverToBoxAdapter(child: Gap(100.h)),
        ],
      ),
    );
  }
}