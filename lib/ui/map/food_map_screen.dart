import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/api/api_client.dart';
import '../../core/route.dart';
import '../../data/model/restaurant.dart';
import '../../providers/community_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/shared/cached_image.dart';

class FoodMapScreen extends ConsumerStatefulWidget {
  const FoodMapScreen({super.key});

  @override
  ConsumerState<FoodMapScreen> createState() => _FoodMapScreenState();
}

class _FoodMapScreenState extends ConsumerState<FoodMapScreen> {
  final MapController _mapController = MapController();
  Position? _userPosition;
  bool _isLoadingLocation = true;
  double _currentZoom = 14.0;
  List<LatLng> _routePoints = [];

  StreamSubscription<Position>? _positionStream;
  Restaurant? _navigatingTo;
  bool _isNavigating = false;

  List<dynamic> _navigationSteps = [];
  int _currentStepIndex = 0;
  String _currentInstruction = "Đang bắt đầu...";
  double _distanceToNextStep = 0;
  Timer? _debounce;
  List<Restaurant> _mapRestaurants = [];

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() async {
    try {
      final initialPos = await locationService.getCurrentPosition();
      if (mounted && initialPos != null) {
        setState(() {
          _userPosition = initialPos;
          _isLoadingLocation = false;
        });

        // 1. Dịch chuyển Camera về vị trí người dùng
        _mapController.move(LatLng(initialPos.latitude, initialPos.longitude), 15.0);

        // 2. TỰ ĐỘNG GỌI API SAU 0.5 GIÂY ĐỂ HIỆN QUÁN (Chữa lỗi phải vuốt mới hiện)
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _fetchRestaurantsInBounds();
          }
        });
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 10),
      ).listen((Position position) {
        if (mounted) setState(() => _userPosition = position);
      });
    } catch (e) {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  String _translateManeuver(Map<String, dynamic> maneuver) {
    String type = maneuver['type'] ?? '';
    String modifier = maneuver['modifier'] ?? '';

    switch (type) {
      case 'turn':
        if (modifier.contains('left')) return "Rẽ trái";
        if (modifier.contains('right')) return "Rẽ phải";
        return "Chuẩn bị rẽ";
      case 'continue':
        return "Tiếp tục đi thẳng";
      case 'depart':
        return "Bắt đầu di chuyển";
      case 'arrive':
        return "Bạn đã tới nơi";
      case 'merge':
        return "Đi vào làn đường chính";
      case 'roundabout':
        return "Đi vào vòng xuyến";
      default:
        return "Tiếp tục đi theo đường";
    }
  }

  Future<void> _startNavigation(Restaurant res) async {
    if (_userPosition == null) return;

    // Sửa thành HTTPS để tránh lỗi bảo mật của Android chặn Request
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${_userPosition!.longitude},${_userPosition!.latitude};${res.longitude},${res.latitude}?geometries=geojson&steps=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];
        final List<dynamic> coords = route['geometry']['coordinates'];

        setState(() {
          _routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
          _navigationSteps = route['legs'][0]['steps'];
          _currentStepIndex = 0;
          _isNavigating = true;
          _navigatingTo = res;
        });
      }
    } catch (e) {
      debugPrint("Lỗi dẫn đường: $e");
    }
  }

  Future<void> _fetchRestaurantsInBounds() async {
    if (_userPosition == null) return;
    final bounds = _mapController.camera.visibleBounds;

    try {
      final data = await apiClient.get(
        '/restaurants/in-bounds',
        queryParameters: {
          'minLat': bounds.south,
          'minLng': bounds.west,
          'maxLat': bounds.north,
          'maxLng': bounds.east,
        },
      );

      final List items = data as List;
      setState(() {
        _mapRestaurants = items.map((e) => parseRestaurantData(e)).toList();
      });
    } catch (e) {
      debugPrint("Lỗi tải quán ăn trên Map: $e");
    }
  }

  void _stopNavigation() {
    setState(() {
      _isNavigating = false;
      _navigatingTo = null;
      _routePoints = [];
      _navigationSteps = [];
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  final Map<String, String> _categoryIcons = const {
    "Bánh": "🍰", "Coffee": "☕", "Lẩu": "🥘", "Bún": "🍜", "Chay": "🥗",
    "Chè": "🍧", "Gà": "🍗", "Nem": "🌯", "Nướng": "🍢", "Ốc": "🐚",
    "Trà sữa": "🧋", "Vịt": "🦆", "Cơm": "🍚",
  };

  final Map<String, Color> _categoryColors = const {
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
  Widget build(BuildContext context) {
    // Không cần dùng ref.watch(communityProvider) ở đây nữa vì Map đã gọi riêng _fetchRestaurantsInBounds

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(21.0285, 105.8542), // Sẽ tự động nhảy về vị trí User
              initialZoom: 14.0,
              onPositionChanged: (camera, hasGesture) {
                if (mounted) setState(() => _currentZoom = camera.zoom);
                if (hasGesture) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 600), () {
                    _fetchRestaurantsInBounds();
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dinos.foodtour',
              ),
              PolylineLayer(
                polylines: [
                  if (_routePoints.isNotEmpty)
                    Polyline(
                      points: _routePoints,
                      color: Colors.blueAccent.withOpacity(0.8),
                      strokeWidth: 6.0,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_userPosition != null)
                    Marker(
                      point: LatLng(
                          _userPosition!.latitude, _userPosition!.longitude),
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.navigation,
                          color: Colors.blue, size: 40),
                    ),
                  ..._mapRestaurants
                      .where((res) => res.latitude != null && res.longitude != null)
                      .map((res) {
                    final isZoomedIn = _currentZoom >= 15.5;
                    final labelText = isZoomedIn
                        ? "${res.name ?? ''}\n⭐${res.rating}"
                        : (res.type ?? '');

                    final String type = res.type ?? "";
                    final Color markerColor = _categoryColors[type] ?? Colors.redAccent;
                    final String markerIcon = _categoryIcons[type] ?? "🍽️";

                    return Marker(
                      point: LatLng(res.latitude!, res.longitude!),
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _showRestaurantQuickView(context, res),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                      style: TextStyle(fontSize: isZoomedIn ? 12 : 14),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        labelText,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isZoomedIn ? 11 : 12,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -7.5),
                                child: Transform.rotate(
                                  angle: 3.14159 / 4,
                                  child: Container(
                                    width: 12,
                                    height: 12,
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
                  }),
                ],
              ),
            ],
          ),
          if (_isNavigating && _navigationSteps.isNotEmpty)
            Positioned(
              top: 50.h,
              left: 16.w,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    _buildStepIcon(_navigationSteps[_currentStepIndex]
                    ['maneuver']['modifier']),
                    Gap(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _distanceToNextStep > 1000
                                ? "${(_distanceToNextStep / 1000).toStringAsFixed(1)} km"
                                : "${_distanceToNextStep.toStringAsFixed(0)} m",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _currentInstruction,
                            style:
                            TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _stopNavigation,
                    )
                  ],
                ),
              ),
            ),
          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_userPosition != null) {
            _mapController.move(
                LatLng(_userPosition!.latitude, _userPosition!.longitude), 16.0);
            _fetchRestaurantsInBounds(); // Cập nhật lại danh sách khi nhấn nút Focus
          }
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  Widget _buildStepIcon(String? modifier) {
    IconData icon;
    if (modifier == null) {
      return const Icon(Icons.straight, color: Colors.white, size: 35);
    }

    if (modifier.contains('left')) {
      icon = Icons.turn_left;
    } else if (modifier.contains('right')) {
      icon = Icons.turn_right;
    } else {
      icon = Icons.straight;
    }
    return Icon(icon, color: Colors.white, size: 40.sp);
  }

  void _showRestaurantQuickView(BuildContext context, Restaurant res) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        height: 200.h,
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedImage(
                    res.imageUrls.isNotEmpty ? res.imageUrls.first : '',
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.name ?? "Đang cập nhật",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(8.h),
                      Text(
                        res.address ?? "Chưa có địa chỉ",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 20),
                          Text(" ${res.rating ?? 5.0}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      push(detailRoute, extra: res);
                    },
                    icon: const Icon(Icons.info_outline, color: Colors.blue),
                    label: const Text("Chi tiết"),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startNavigation(res);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Bắt đầu"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}