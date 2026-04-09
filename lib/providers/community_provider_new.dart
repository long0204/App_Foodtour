import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/model/restaurant.dart';
import '../core/api/api_client.dart';
import '../../utils/logger.dart';

part 'community_provider.g.dart';

// ==================== Suggestion Provider ====================

@riverpod
class Suggestion extends _$Suggestion {
  String currentMealType = "bạn";
  
  // Cache for suggestions
  final Map<String, List<Restaurant>> _cache = {};
  final Map<String, DateTime> _cacheTime = {};
  static const _cacheDuration = Duration(minutes: 5);

  @override
  FutureOr<List<Restaurant>> build() {
    return [];
  }

  Future<void> fetchSuggestions(double lat, double lng) async {
    final cacheKey = '${lat}_${lng}';
    
    // Check cache first
    if (_cache.containsKey(cacheKey)) {
      final cacheAge = DateTime.now().difference(_cacheTime[cacheKey]!);
      if (cacheAge < _cacheDuration) {
        state = AsyncValue.data(_cache[cacheKey]!);
        return;
      }
    }
    
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final data = await apiClient.get(
        '/restaurants/suggestions',
        queryParameters: {'lat': lat, 'lng': lng},
      );

      currentMealType = data['meal_type'] ?? 'bạn';
      final List items = data['restaurants'] ?? [];

      final list = items.map((e) => parseRestaurantData(e)).toList();
      
      // Update cache
      _cache[cacheKey] = list;
      _cacheTime[cacheKey] = DateTime.now();

      return list;
    });
  }
  
  void clearCache() {
    _cache.clear();
    _cacheTime.clear();
  }
}

// ==================== Community Restaurant Provider ====================

@riverpod
class CommunityRestaurant extends _$CommunityRestaurant {
  // Cache
  List<Restaurant>? _cachedData;
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 10);
  
  @override
  FutureOr<List<Restaurant>> build() async {
    return fetchAllRestaurants();
  }
  
  Future<List<Restaurant>> fetchAllRestaurants() async {
    // Check cache first
    if (_cachedData != null && _cacheTime != null) {
      final cacheAge = DateTime.now().difference(_cacheTime!);
      if (cacheAge < _cacheDuration) {
        return _cachedData!;
      }
    }
    
    final data = await apiClient.get('/restaurants');
    final List items = data as List;

    final list = items.map((e) => parseRestaurantData(e)).toList();
    
    // Update cache
    _cachedData = list;
    _cacheTime = DateTime.now();

    return list;
  }
  
  void clearCache() {
    _cachedData = null;
    _cacheTime = null;
    ref.invalidateSelf();
  }
}

// ==================== Helper Functions ====================

double _decodeEWKBDouble(String hex) {
  final bytes = Uint8List(8);
  for (int i = 0; i < 8; i++) {
    bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return ByteData.view(bytes.buffer).getFloat64(0, Endian.little);
}

Restaurant parseRestaurantData(dynamic e) {
  final map = Map<String, dynamic>.from(e);

  final rawName = map['name'] ?? map['Name'] ?? map['Tên quán'] ?? '';
  final rawAddress = map['address'] ?? map['Address'] ?? map['Địa chỉ'] ?? '';
  final rawType = map['type'] ?? map['Type'] ?? map['Loại'] ?? '';
  final rawPrice = map['price'] ?? map['Price'] ?? map['Giá'] ?? '';
  final rawRating = map['rating'] ?? map['Rating'] ?? 5.0;
  final rawDesc = map['description'] ?? map['Review'] ?? '';

  map['name'] = map['Name'] = map['Tên quán'] = rawName;
  map['address'] = map['Address'] = map['Địa chỉ'] = rawAddress;
  map['type'] = map['Type'] = map['Loại'] = rawType;
  map['price'] = map['Price'] = map['Giá'] = rawPrice;
  map['rating'] = map['Rating'] = rawRating;
  map['description'] = map['Review'] = rawDesc;

  if (map['image_urls'] != null) {
    map['imageUrls'] = map['image_urls'];
  }

  if (map['location'] != null) {
    String loc = map['location'].toString();
    if (loc.startsWith('POINT')) {
      loc = loc.replaceAll('POINT(', '').replaceAll(')', '');
      final coords = loc.split(' ');
      if (coords.length == 2) {
        map['longitude'] = map['lng'] = double.tryParse(coords[0]);
        map['latitude'] = map['lat'] = double.tryParse(coords[1]);
      }
    } else if (loc.startsWith('0101000020E6100000') && loc.length >= 50) {
      try {
        String lngHex = loc.substring(18, 34);
        String latHex = loc.substring(34, 50);
        map['longitude'] = map['lng'] = _decodeEWKBDouble(lngHex);
        map['latitude'] = map['lat'] = _decodeEWKBDouble(latHex);
      } catch (e) {
        logger.e("Lỗi giải mã tọa độ Hex: $e");
      }
    }
  }

  return Restaurant.fromJson(map);
}
