import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../data/model/favorite_address_model.dart';
import '../../favorite_address/providers/state.dart';
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

  Future<void> addFavoritePlace(WidgetRef ref, Map<String, dynamic> item) async {
    final place = FavoritePlace(
      name: item['Tên quán'],
      address: item['Địa chỉ'],
      type: item['Loại'] ?? 'Không có',
      price: item['Giá'] ?? '0.0',
    );

    // Lưu vào Hive
    var box = await Hive.openBox<FavoritePlace>('favorites');
    await box.add(place);

    // Lưu vào Firebase Firestore
    await FirebaseFirestore.instance.collection('favorite_places').add({
      'name': place.name,
      'address': place.address,
      'type': place.type,
      'price': place.price,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Tải lại danh sách địa điểm yêu thích từ Hive
    ref.read(favoritePlacesProvider.notifier).loadFavoritePlaces();
  }
}
