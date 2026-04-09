import 'dart:async';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/api_client_provider.dart';
import '../../../../data/model/restaurant.dart';
import '../../../../services/location_service.dart';
import '../../../providers/community_provider.dart';

part 'notifier.g.dart';

class FoodMapState {
  final Position? userPosition;
  final bool isLoadingLocation;
  final double currentZoom;
  final List<Restaurant> mapRestaurants;

  final bool isNavigating;
  final Restaurant? navigatingTo;
  final List<LatLng> routePoints;
  final List<dynamic> navigationSteps;
  final int currentStepIndex;
  final String currentInstruction;
  final double distanceToNextStep;

  FoodMapState({
    this.userPosition,
    this.isLoadingLocation = true,
    this.currentZoom = 14.0,
    this.mapRestaurants = const [],
    this.isNavigating = false,
    this.navigatingTo,
    this.routePoints = const [],
    this.navigationSteps = const [],
    this.currentStepIndex = 0,
    this.currentInstruction = "Đang bắt đầu...",
    this.distanceToNextStep = 0.0,
  });

  FoodMapState copyWith({
    Position? userPosition,
    bool? isLoadingLocation,
    double? currentZoom,
    List<Restaurant>? mapRestaurants,
    bool? isNavigating,
    Restaurant? navigatingTo,
    List<LatLng>? routePoints,
    List<dynamic>? navigationSteps,
    int? currentStepIndex,
    String? currentInstruction,
    double? distanceToNextStep,
  }) {
    return FoodMapState(
      userPosition: userPosition ?? this.userPosition,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      currentZoom: currentZoom ?? this.currentZoom,
      mapRestaurants: mapRestaurants ?? this.mapRestaurants,
      isNavigating: isNavigating ?? this.isNavigating,
      navigatingTo: navigatingTo ?? this.navigatingTo,
      routePoints: routePoints ?? this.routePoints,
      navigationSteps: navigationSteps ?? this.navigationSteps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentInstruction: currentInstruction ?? this.currentInstruction,
      distanceToNextStep: distanceToNextStep ?? this.distanceToNextStep,
    );
  }
}

@riverpod
class FoodMapNotifier extends _$FoodMapNotifier {
  StreamSubscription<Position>? _positionStream;

  @override
  FoodMapState build() {
    _initLocationTracking();

    ref.onDispose(() {
      _positionStream?.cancel();
    });

    return FoodMapState();
  }

  Future<void> _initLocationTracking() async {
    try {
      final initialPos = await locationService.getCurrentPosition();
      if (initialPos != null) {
        state = state.copyWith(userPosition: initialPos, isLoadingLocation: false);
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
      ).listen((Position position) {
        state = state.copyWith(userPosition: position);
      });
    } catch (e) {
      state = state.copyWith(isLoadingLocation: false);
    }
  }

  void updateZoom(double zoom) {
    state = state.copyWith(currentZoom: zoom);
  }

  Future<void> fetchRestaurantsInBounds(LatLngBounds bounds) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.get(
        '/restaurants/in-bounds',
        queryParameters: {
          'minLat': bounds.south, 'minLng': bounds.west,
          'maxLat': bounds.north, 'maxLng': bounds.east,
        },
      );
      final List items = data as List;
      state = state.copyWith(mapRestaurants: items.map((e) => parseRestaurantData(e)).toList());
    } catch (e) {
      print("Lỗi tải quán ăn trên Map: $e");
    }
  }

  Future<void> startNavigation(Restaurant res) async {
    if (state.userPosition == null) return;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${state.userPosition!.longitude},${state.userPosition!.latitude};${res.longitude},${res.latitude}?geometries=geojson&steps=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];
        final List<dynamic> coords = route['geometry']['coordinates'];
        final steps = route['legs'][0]['steps'];

        state = state.copyWith(
          routePoints: coords.map((c) => LatLng(c[1], c[0])).toList(),
          navigationSteps: steps,
          currentStepIndex: 0,
          isNavigating: true,
          navigatingTo: res,
          currentInstruction: _translateManeuver(steps[0]['maneuver']),
          distanceToNextStep: (steps[0]['distance'] as num).toDouble(),
        );
      }
    } catch (e) {
      print("Lỗi dẫn đường: $e");
    }
  }

  void stopNavigation() {
    state = state.copyWith(
      isNavigating: false,
      navigatingTo: null,
      routePoints: [],
      navigationSteps: [],
    );
  }

  String _translateManeuver(Map<String, dynamic> maneuver) {
    String type = maneuver['type'] ?? '';
    String modifier = maneuver['modifier'] ?? '';
    switch (type) {
      case 'turn':
        if (modifier.contains('left')) return "Rẽ trái";
        if (modifier.contains('right')) return "Rẽ phải";
        return "Chuẩn bị rẽ";
      case 'continue': return "Tiếp tục đi thẳng";
      case 'depart': return "Bắt đầu di chuyển";
      case 'arrive': return "Bạn đã tới nơi";
      case 'merge': return "Đi vào làn đường chính";
      case 'roundabout': return "Đi vào vòng xuyến";
      default: return "Tiếp tục đi theo đường";
    }
  }
}