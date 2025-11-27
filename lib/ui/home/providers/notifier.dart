import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../data/model/restaurant.dart';
import '../../../data/sources/remote/google_service.dart';

part 'state.dart';

class RandomItemNotifier extends StateNotifier<RandomItemState> {
  RandomItemNotifier() : super(RandomItemState.initial()) {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final data = await fetchGoogleSheetItems();

      final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();

      final box = Hive.box<Restaurant>('restaurants');
      await box.clear();
      await box.addAll(restaurants);

      final items = restaurants.map((e) => e.toMap()).toList();

      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void loadFromHive() {
    final box = Hive.box<Restaurant>('restaurants');
    final items = box.values.map((e) => e.toMap()).toList();

    state = state.copyWith(items: items, isLoading: false);
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
StateNotifierProvider<RandomItemNotifier, RandomItemState>(
      (ref) => RandomItemNotifier(),
);
