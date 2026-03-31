import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/restaurant.dart';
import '../core/api/api_client.dart';
import '../../utils/logger.dart';

class SuggestionNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  SuggestionNotifier() : super(const AsyncValue.loading());
  String currentMealType = "bạn";

  Future<void> fetchSuggestions(double lat, double lng) async {
    state = const AsyncValue.loading();
    try {
      final data = await apiClient.get(
        '/restaurants/suggestions',
        queryParameters: {'lat': lat, 'lng': lng},
      );

      currentMealType = data['meal_type'] ?? 'bạn';
      final List items = data['restaurants'] ?? [];

      final list = items.map((e) => parseRestaurantData(e)).toList();

      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}
final suggestionProvider = StateNotifierProvider<SuggestionNotifier, AsyncValue<List<Restaurant>>>((ref) => SuggestionNotifier());

class CommunityRestaurantNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  CommunityRestaurantNotifier() : super(const AsyncValue.loading()) {
    fetchAllRestaurants();
  }

  Future<void> fetchAllRestaurants() async {
    try {
      final data = await apiClient.get('/restaurants');
      final List items = data as List;

      final list = items.map((e) => parseRestaurantData(e)).toList();

      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}
final communityProvider = StateNotifierProvider<CommunityRestaurantNotifier, AsyncValue<List<Restaurant>>>((ref) => CommunityRestaurantNotifier());

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