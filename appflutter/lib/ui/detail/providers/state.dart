import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  final Map<String, dynamic> selectedItem;
  final bool isLoading;

  const DetailState({
    required this.selectedItem,
    this.isLoading = false,
  });

  DetailState copyWith({
    Map<String, dynamic>? selectedItem,
    bool? isLoading,
  }) {
    return DetailState(
      selectedItem: selectedItem ?? this.selectedItem,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedItem, isLoading];
}

