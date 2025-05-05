import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/sources/remote/google_service.dart';

part 'state.dart';

class RandomItemNotifier extends StateNotifier<RandomItemState> {
  RandomItemNotifier() : super(RandomItemState.initial()) {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final data = await fetchGoogleSheetItems();
      state = state.copyWith(items: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
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
