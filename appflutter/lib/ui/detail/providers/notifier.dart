// detail_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state.dart';

final detailNotifierProvider = NotifierProvider<DetailNotifier, DetailState>(
  DetailNotifier.new,
);

class DetailNotifier extends Notifier<DetailState> {
  @override
  DetailState build() {
    return const DetailState(selectedItem: {});
  }

  void setSelectedItem(Map<String, dynamic> item) {
    state = DetailState(selectedItem: item);
  }
}
