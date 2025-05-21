import 'dart:async';
import 'package:Foodtour/ui/list_address/providers/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Foodtour/data/model/restaurant.dart';
import 'package:hive/hive.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../../config/constants/env.dart';
import '../../../data/sources/remote/google_service.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class RestaurantNotifier extends _$RestaurantNotifier {
  Timer? _debounce;

  @override
  RestaurantState build() {
    final box = Hive.box<Restaurant>('restaurants');
    final items = box.values.toList();

    ref.onDispose(() {
      _debounce?.cancel();
    });

    return RestaurantState(
      allRestaurants: items,
      filteredRestaurants: items,
    );
  }

  void search(String query) {
    _debounce?.cancel();

    state = state.copyWith(isLoading: true);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      List<MapEntry<Restaurant, double>> scored;

      if (query.isEmpty) {
        scored = state.allRestaurants
            .map((r) => MapEntry(r, 1.0))
            .toList();
      } else {
        final lower = query.toLowerCase().trim();

        scored = state.allRestaurants
            .map((r) {
          final nameSimilarity = StringSimilarity.compareTwoStrings(
              r.name?.toLowerCase() ?? '', lower);
          final addressSimilarity = StringSimilarity.compareTwoStrings(
              r.address?.toLowerCase() ?? '', lower);
          final score = nameSimilarity > addressSimilarity
              ? nameSimilarity
              : addressSimilarity;
          return MapEntry(r, score);
        })
            .where((entry) => entry.value > 0.3)
            .toList();
      }

      scored.sort((a, b) => b.value.compareTo(a.value));

      final results = scored.map((e) => e.key).toList();

      state = state.copyWith(
        filteredRestaurants: results,
        isLoading: false,
      );
    });
  }

  void filterByType(String? type) {
    if (type == null) {
      // Hiển thị lại tất cả
      state = state.copyWith(
        selectedType: null,
        filteredRestaurants: state.allRestaurants,
      );
      return;
    }

    final results = state.allRestaurants.where((r) => r.type == type).toList();
    state = state.copyWith(
      selectedType: type,
      filteredRestaurants: results,
    );
  }

  Future<void> refreshFromRemote() async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await fetchGoogleSheetItems();
      final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();

      final box = Hive.box<Restaurant>('restaurants');
      await box.clear();
      await box.addAll(restaurants);

      state = state.copyWith(
        allRestaurants: restaurants,
        filteredRestaurants: restaurants,
        isLoading: false,
        selectedType: null,
      );
    } catch (e) {
      debugPrint("Lỗi khi load từ Google Sheets: $e");
      state = state.copyWith(isLoading: false);
    }
  }
  // Future<void> addNewRestaurant({required type, required name, required address, required price}) async {
  //   final url = Uri.parse(ENV.urlscripts);
  //
  //   final response = await http.post(url, body: {
  //     "Type": type,
  //     "Name": name,
  //     "Address": address,
  //     "Price": price ?? '0',
  //   });
  //   if (response.statusCode == 200) {
  //     print("Success: ${response.body}");
  //   }
  //   else {
  //     print("Response code: ${response.statusCode}");
  //     print("Response body: ${response.body}");
  //     throw Exception('Lỗi khi upload dữ liệu');
  //   }
  // }
  Future<void> addNewRestaurant({
    required String type,
    required String name,
    required String address,
    required String price,
  }) async {
    final url = Uri.parse(ENV.urlscripts);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "Type": type,
        "Name": name,
        "Address": address,
        "Price": price.isNotEmpty ? price : '0',
      },
    );

    if (response.statusCode == 200) {
      print("✅ Success: ${response.body}");
    } else {
      print("❌ Response code: ${response.statusCode}");
      print("❌ Response body: ${response.body}");
      //throw Exception('Lỗi khi upload dữ liệu');
    }
  }

}
