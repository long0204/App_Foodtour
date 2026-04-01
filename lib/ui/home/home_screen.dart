import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:Foodtour/ui/home/widget/restaurant_card.dart';
import 'package:Foodtour/widgets/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../config/gen/assets.gen.dart';
import '../../config/themes/text_style.dart';
import '../../core/route.dart';
import '../../providers/community_provider.dart';
import '../../providers/tab_provider.dart';
import '../../services/location_service.dart';
import '../../services/remote_config_service.dart';
import '../../utils/string.dart';
import '../../widgets/shared/cached_image.dart';
import '../auth/providers/auth_notifier.dart';
import '../list_address/restaurant_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Position? _userPosition;
  late ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode();

  bool _isCollapsed = false;
  bool _isSearchFocused = false;
  final Map<String, String> _categoryIcons = const {
    "Bánh": "🍰", "Coffee": "☕", "Lẩu": "🥘", "Bún": "🍜", "Chay": "🥗",
    "Chè": "🍧", "Gà": "🍗", "Nem": "🌯", "Nướng": "🍢", "Ốc": "🐚",
    "Trà sữa": "🧋", "Vịt": "🦆", "Cơm": "🍚",
  };

  // Bộ Màu sắc tương ứng
  final Map<String, Color> _categoryColors = const {
    "Bánh": Colors.pinkAccent, "Coffee": Colors.brown, "Lẩu": Colors.deepOrange,
    "Bún": Colors.orange, "Chay": Colors.green, "Chè": Colors.purpleAccent,
    "Gà": Colors.amber, "Nem": Colors.lime, "Nướng": Colors.deepOrangeAccent,
    "Ốc": Colors.teal, "Trà sữa": Colors.pink, "Vịt": Colors.orangeAccent,
    "Cơm": Colors.blueAccent,
  };

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final threshold = 200.h - kToolbarHeight;
      if (_scrollController.offset > threshold && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= threshold && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final position = await locationService.getCurrentPosition();
      if (mounted && position != null) {
        setState(() => _userPosition = position);
        // Gọi API gợi ý
        ref.read(suggestionProvider.notifier).fetchSuggestions(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint("Lỗi GPS Home: $e");
    }
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return Icons.wb_sunny_rounded;
    } else if (hour >= 12 && hour < 18) {
      return Icons.wb_cloudy_rounded;
    } else {
      return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionAsync = ref.watch(suggestionProvider);
    final allRestaurantsAsync = ref.watch(communityProvider);

    final greeting = getGreeting(context);
    final greetingIcon = _getGreetingIcon();
    final userData = ref.watch(userFirestoreProvider).value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            title: _isSearchFocused
                ? Text("Bạn muốn tìm địa điểm nào?", style: k2d500.s16.white)
                : (_isCollapsed
                ? Text("Hôm nay bạn muốn ăn gì?", style: k2d500.s16.white)
                : null),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedImage(RemoteConfigService().imageAppbarHome,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: Assets.images.home.bestfood.image(),
                      placeholder: Assets.images.home.bestfood.image()),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70.h,
                    left: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("$greeting", style: k2d400.s16.white),
                            Gap(4.w),
                            Icon(
                              greetingIcon,
                              color: Colors.amberAccent,
                              size: 14.sp,
                            ),
                          ],
                        ),
                        Text(" ${userData?['fullname'] ?? ''}", style: k2d400.s16.white),
                        Text("Hôm nay bạn muốn ăn gì?",
                            style: k2d500.s24.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30.h),
              child: ZoomTap(
                onTap: () {
                  ref.read(autoFocusSearchProvider.notifier).state = true;
                  ref.read(tabIndexProvider.notifier).state = 3;
                },
                child: Transform.translate(
                  offset:
                  Offset(0, (_isSearchFocused || _isCollapsed) ? 0 : 30.h),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5))
                        ],
                      ),
                      child: IgnorePointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Tìm quán ăn, món ăn...",
                            prefixIcon: const Icon(Icons.search,
                                color: Colors.redAccent),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Gap(40.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Địa điểm gần bạn", style: k2d500.s16),
                    ],
                  ),
                  Gap(12.h),
                  ZoomTap(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = 1;
                    },
                    child: Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ],
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: (_userPosition == null)
                            ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Đang lấy vị trí",
                                    style: k2d400.copyWith(
                                        color: Colors.grey, fontSize: 14.sp)),
                                WaveLoadingText(
                                  text: "...",
                                  style: k2d400.copyWith(
                                      color: Colors.grey, fontSize: 14.sp),
                                ),
                              ],
                            ))
                            : FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                            initialZoom: 13,
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
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                      Icons.person_pin_circle_sharp,
                                      color: Colors.blue,
                                      size: 35),
                                ),

                                ...allRestaurantsAsync.maybeWhen(
                                  data: (list) {
                                    final hasLatLng = list.where((r) => r.latitude != null && r.longitude != null).toList();

                                    hasLatLng.sort((a, b) {
                                      final distA = const Distance().distance(
                                          LatLng(_userPosition!.latitude, _userPosition!.longitude),
                                          LatLng(a.latitude!, a.longitude!)
                                      );
                                      final distB = const Distance().distance(
                                          LatLng(_userPosition!.latitude, _userPosition!.longitude),
                                          LatLng(b.latitude!, b.longitude!)
                                      );
                                      return distA.compareTo(distB);
                                    });

                                      return hasLatLng.take(5).map((res) {
                                        // Xác định Màu, Icon và Text
                                        final String type = res.type ?? "";
                                        final Color markerColor = _categoryColors[type] ?? Colors.redAccent;
                                        final String markerIcon = _categoryIcons[type] ?? "🍽️";
                                        final String labelText = type.isNotEmpty ? type : "Quán ngon";

                                        return Marker(
                                          point: LatLng(res.latitude!, res.longitude!),
                                          width: 120, // Kích thước khung vẽ
                                          height: 80,
                                          alignment: Alignment.center, // Căn giữa
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                push(detailRoute, extra: res);
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: markerColor,
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(color: Colors.white, width: 1.5),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Colors.black26,
                                                            blurRadius: 4,
                                                            offset: Offset(0, 2))
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          markerIcon,
                                                          style: TextStyle(fontSize: 12.sp),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            labelText,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 10.sp,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: const Offset(0, -6),
                                                    child: Transform.rotate(
                                                      angle: 3.14159 / 4,
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration: BoxDecoration(
                                                          color: markerColor,
                                                          border: const Border(
                                                            bottom: BorderSide(color: Colors.white, width: 1.5),
                                                            right: BorderSide(color: Colors.white, width: 1.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList();
                                  },
                                  orElse: () => <Marker>[], // Chống lỗi List<dynamic>
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
              child: Consumer(
                builder: (context, ref, child) {
                  final mealType = ref.watch(suggestionProvider.notifier).currentMealType;
                  return Text(
                      mealType == 'bạn' ? "Đề xuất cho bạn" : "Gợi ý cho bạn nên chọn $mealType",
                      style: k2d500.s16
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: suggestionAsync.when(
              data: (list) {
                list.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));

                if (list.isEmpty) {
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
                      final restaurant = list[index];
                      return ZoomTap(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          push(detailRoute, extra: restaurant);
                        },
                        child: RestaurantCardVertical(restaurant: restaurant),
                      );
                    },
                    childCount: list.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator())),
              error: (err, stack) =>
                  SliverToBoxAdapter(child: Center(child: Text("Lỗi: $err"))),
            ),
          ),
          SliverToBoxAdapter(child: Gap(120.h)),
        ],
      ),
    );
  }
}

class WaveLoadingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const WaveLoadingText({super.key, required this.text, required this.style});

  @override
  State<WaveLoadingText> createState() => _WaveLoadingTextState();
}

class _WaveLoadingTextState extends State<WaveLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double offset =
                math.sin((_controller.value * 2 * math.pi) - (index * 0.3)) *
                    2.5;
            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
          },
          child: Text(widget.text[index], style: widget.style),
        );
      }),
    );
  }
}