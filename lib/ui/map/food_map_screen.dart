import 'dart:async';
import 'package:Foodtour/ui/map/providers/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/map_constants.dart';
import 'widgets/navigation_panel.dart';
import 'widgets/restaurant_quick_view.dart';

class FoodMapScreen extends ConsumerStatefulWidget {
  const FoodMapScreen({super.key});

  @override
  ConsumerState<FoodMapScreen> createState() => _FoodMapScreenState();
}

class _FoodMapScreenState extends ConsumerState<FoodMapScreen> {
  final MapController _mapController = MapController();
  Timer? _debounce;
  bool _hasInitialMoved = false;

  @override
  void dispose() {
    _mapController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Sửa MapPosition thành MapCamera
  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      ref.read(foodMapNotifierProvider.notifier).updateZoom(camera.zoom);

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
          ref
              .read(foodMapNotifierProvider.notifier)
              .fetchRestaurantsInBounds(_mapController.camera.visibleBounds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodMapNotifierProvider);
    final notifier = ref.read(foodMapNotifierProvider.notifier);

    if (!_hasInitialMoved && state.userPosition != null) {
      _hasInitialMoved = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
            LatLng(state.userPosition!.latitude, state.userPosition!.longitude),
            15.0);
        notifier.fetchRestaurantsInBounds(_mapController.camera.visibleBounds);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(21.0285, 105.8542),
              initialZoom: 14.0,
              onPositionChanged: _onMapPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dinos.foodtour',
              ),
              PolylineLayer(
                polylines: [
                  if (state.routePoints.isNotEmpty)
                    Polyline(
                        points: state.routePoints,
                        color: Colors.blueAccent.withOpacity(0.8),
                        strokeWidth: 6.0),
                ],
              ),
              MarkerLayer(
                markers: [
                  // 1. Marker User
                  if (state.userPosition != null)
                    Marker(
                      point: LatLng(state.userPosition!.latitude,
                          state.userPosition!.longitude),
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.navigation,
                          color: Colors.blue, size: 40),
                    ),

                  // 2. Marker Quán Ăn
                  ...state.mapRestaurants
                      .where((res) =>
                          res.latitude != null && res.longitude != null)
                      .map((res) {
                    final isZoomedIn = state.currentZoom >= 15.5;
                    final labelText = isZoomedIn
                        ? "${res.name ?? ''}\n⭐${res.rating}"
                        : (res.type ?? '');
                    final type = res.type ?? "";
                    final markerColor =
                        MapConstants.categoryColors[type] ?? Colors.redAccent;
                    final markerIcon =
                        MapConstants.categoryIcons[type] ?? "🍽️";

                    return Marker(
                      point: LatLng(res.latitude!, res.longitude!),
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>
                              showRestaurantQuickView(context, ref, res),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: markerColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
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
                                            fontSize: isZoomedIn ? 12 : 14)),
                                    const SizedBox(width: 4),
                                    Flexible(
                                        child: Text(labelText,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isZoomedIn ? 11 : 12),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis)),
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
                                                bottom: BorderSide(
                                                    color: Colors.white,
                                                    width: 1.5),
                                                right: BorderSide(
                                                    color: Colors.white,
                                                    width: 1.5))))),
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
          const NavigationPanel(),
          if (state.isLoadingLocation)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (state.userPosition != null) {
            _mapController.move(
                LatLng(state.userPosition!.latitude,
                    state.userPosition!.longitude),
                16.0);
            notifier
                .fetchRestaurantsInBounds(_mapController.camera.visibleBounds);
          }
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }
}
