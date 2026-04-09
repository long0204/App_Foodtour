import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/route.dart';
import '../../../../providers/community_provider.dart';
import '../../../../widgets/shared/shimmer.dart';
import '../../../../widgets/base/base.dart';
import '../../../providers/tab_provider.dart';

class HomeMapSection extends ConsumerWidget {
  final Position? userPosition;
  final bool isLoadingLocation;

  const HomeMapSection({
    super.key,
    required this.userPosition,
    required this.isLoadingLocation,
  });

  static const Map<String, String> _categoryIcons = {
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

  static const Map<String, Color> _categoryColors = {
    "Bánh": Colors.pinkAccent,
    "Coffee": Colors.brown,
    "Lẩu": Colors.deepOrange,
    "Bún": Colors.orange,
    "Chay": Colors.green,
    "Chè": Colors.purpleAccent,
    "Gà": Colors.amber,
    "Nem": Colors.lime,
    "Nướng": Colors.deepOrangeAccent,
    "Ốc": Colors.teal,
    "Trà sữa": Colors.pink,
    "Vịt": Colors.orangeAccent,
    "Cơm": Colors.blueAccent,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRestaurantsAsync = ref.watch(communityProvider);

    return ZoomTap(
      onTap: () {
        ref.read(tabIndexProvider.notifier).state = 1;
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: (userPosition == null ||
                  isLoadingLocation ||
                  allRestaurantsAsync.isLoading)
              ? ShimmerLoading(height: 150.h, radius: 15.r)
              : FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        LatLng(userPosition!.latitude, userPosition!.longitude),
                    initialZoom: 13,
                    interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.dinos.foodtour',
                    ),
                    MarkerLayer(
                      markers: [
                        // Marker User
                        Marker(
                          point: LatLng(
                              userPosition!.latitude, userPosition!.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.person_pin_circle_sharp,
                              color: Colors.blue, size: 35),
                        ),

                        // Marker Nhà hàng
                        ...allRestaurantsAsync.maybeWhen(
                          data: (list) {
                            final hasLatLng = list
                                .where((r) =>
                                    r.latitude != null && r.longitude != null)
                                .toList();
                            hasLatLng.sort((a, b) {
                              final distA = const Distance().distance(
                                  LatLng(userPosition!.latitude,
                                      userPosition!.longitude),
                                  LatLng(a.latitude!, a.longitude!));
                              final distB = const Distance().distance(
                                  LatLng(userPosition!.latitude,
                                      userPosition!.longitude),
                                  LatLng(b.latitude!, b.longitude!));
                              return distA.compareTo(distB);
                            });

                            return hasLatLng.take(5).map((res) {
                              final String type = res.type ?? "";
                              final Color markerColor =
                                  _categoryColors[type] ?? Colors.redAccent;
                              final String markerIcon =
                                  _categoryIcons[type] ?? "🍽️";
                              final String labelText =
                                  type.isNotEmpty ? type : "Quán ngon";

                              return Marker(
                                point: LatLng(res.latitude!, res.longitude!),
                                width: 120,
                                height: 80,
                                alignment: Alignment.center,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => push(detailRoute, extra: res),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: markerColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.5),
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
                                              Text(markerIcon,
                                                  style: TextStyle(
                                                      fontSize: 12.sp)),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  labelText,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.sp),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                    bottom: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.5)),
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
                          orElse: () => <Marker>[],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
