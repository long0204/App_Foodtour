part of 'notifier.dart';

class RandomItemState extends Equatable {
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> selectedItem;
  final String selectedLoai;
  final bool isLoading;

  const RandomItemState({
    required this.items,
    required this.selectedItem,
    required this.selectedLoai,
    required this.isLoading,
  });

  factory RandomItemState.initial() => RandomItemState(
    items: [],
    selectedItem: {
      "STT": 0,
      "Loại": "Chọn loại quán",
      "Tên quán": "Tên cửa hàng",
      "Địa chỉ": "Địa chỉ",
      "Giá": "",
    },
    selectedLoai: "Chọn loại quán",
    isLoading: true,
  );

  RandomItemState copyWith({
    List<Map<String, dynamic>>? items,
    Map<String, dynamic>? selectedItem,
    String? selectedLoai,
    bool? isLoading,
  }) {
    return RandomItemState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      selectedLoai: selectedLoai ?? this.selectedLoai,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, selectedItem, selectedLoai, isLoading];
}
