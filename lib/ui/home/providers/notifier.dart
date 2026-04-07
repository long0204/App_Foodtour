import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../data/model/restaurant.dart';
import '../../../data/sources/remote/google_service.dart';

part 'state.dart';

class RandomItemNotifier extends StateNotifier<RandomItemState> {
  RandomItemNotifier() : super(RandomItemState.initial());
  
  // Cache
  List<Map<String, dynamic>>? _cachedItems;
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 15);

  Future<void> loadItems() async {
    // Check cache first
    if (_cachedItems != null && _cacheTime != null) {
      final cacheAge = DateTime.now().difference(_cacheTime!);
      if (cacheAge < _cacheDuration) {
        state = state.copyWith(items: _cachedItems!, isLoading: false);
        return;
      }
    }
    
    try {
      final data = await fetchGoogleSheetItems();

      final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();

      final box = Hive.box<Restaurant>('restaurants');
      await box.clear();
      await box.addAll(restaurants);

      final items = restaurants.map((e) => e.toMap()).toList();
      
      // Update cache
      _cachedItems = items;
      _cacheTime = DateTime.now();

      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      debugPrint('❌ Error loading items: $e');
      state = state.copyWith(isLoading: false);
      // Try to load from Hive as fallback
      loadFromHive();
    }
  }

  void loadFromHive() {
    try {
      final box = Hive.box<Restaurant>('restaurants');
      final items = box.values.map((e) => e.toMap()).toList();
      
      // Update cache
      _cachedItems = items;
      _cacheTime = DateTime.now();

      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      debugPrint('❌ Error loading from Hive: $e');
      state = state.copyWith(isLoading: false);
    }
  }
  
  @override
  void dispose() {
    _cachedItems = null;
    _cacheTime = null;
    super.dispose();
  }



  void selectLoai(String loai) {
    state = state.copyWith(selectedLoai: loai);
  }



  void getRandomItem() {
    if (state.selectedLoai == "Chọn loại quán") return;

    final filteredList =
    state.items.where((item) => item["Loại"] == state.selectedLoai).toList();

    if (filteredList.isNotEmpty) {
      final randomIndex = Random().nextInt(filteredList.length);
      state = state.copyWith(selectedItem: filteredList[randomIndex]);
    } else {
      state = state.copyWith(
        selectedItem: {
          "STT": 0,
          "Loại": "Không có loại phù hợp",
          "Tên quán": "",
          "Địa chỉ": "",
          "Giá": ""
        },
      );
    }
  }

  List<String> getLoaiList() {
    final loais = state.items.map((e) => e["Loại"].toString()).toSet().toList();
    loais.sort();
    return ["Chọn loại quán", ...loais];
  }
}

final randomItemNotifierProvider =
StateNotifierProvider.autoDispose<RandomItemNotifier, RandomItemState>(
      (ref) {
    final notifier = RandomItemNotifier();
    // Load items on first access
    notifier.loadItems();
    return notifier;
  },
);
