import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  final Map<String, dynamic> selectedItem;

  const DetailState({required this.selectedItem});

  @override
  List<Object?> get props => [selectedItem];
}
