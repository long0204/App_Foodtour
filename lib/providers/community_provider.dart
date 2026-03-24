// File: community_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/restaurant.dart';
import '../../data/model/review.dart'; // Import model Review

class CommunityRestaurantNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  CommunityRestaurantNotifier() : super(const AsyncValue.loading()) {
    fetchCommunityRestaurants();
  }

  final _db = FirebaseFirestore.instance;

  Future<void> fetchCommunityRestaurants() async {
    try {
      final snapshot = await _db.collection('restaurants').orderBy('Rating', descending: true).get();
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Restaurant.fromJson(data);
      }).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> uploadNewRestaurant(Restaurant restaurant) async {
    try {
      // Dùng hàm .set() thay vì .add() để ép Firebase lưu đúng ID mà ta đã tạo từ app
      await _db.collection('restaurants').doc(restaurant.id).set(restaurant.toMap());
      await fetchCommunityRestaurants();
    } catch (e) {
      rethrow;
    }
  }

  // HÀM MỚI: Thêm review vào mảng 'reviews' của Document quán ăn
  Future<void> addReview(String restaurantId, Review review) async {
    try {
      await _db.collection('restaurants').doc(restaurantId).update({
        // FieldValue.arrayUnion giúp thêm 1 object JSON vào mảng có sẵn mà không đè mất data cũ
        'reviews': FieldValue.arrayUnion([review.toMap()])
      });
      await fetchCommunityRestaurants(); // Cập nhật lại danh sách sau khi rate
    } catch (e) {
      rethrow;
    }
  }
}

final communityProvider = StateNotifierProvider<CommunityRestaurantNotifier, AsyncValue<List<Restaurant>>>(
      (ref) => CommunityRestaurantNotifier(),
);