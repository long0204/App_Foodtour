import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/restaurant.dart';

class CommunityRestaurantNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  CommunityRestaurantNotifier() : super(const AsyncValue.loading()) {
    fetchCommunityRestaurants();
  }

  final _db = FirebaseFirestore.instance;

  Future<void> fetchCommunityRestaurants() async {
    try {
      final snapshot = await _db.collection('restaurants').orderBy('rating', descending: true).get();
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['STT'] = doc.id;
        return Restaurant.fromJson(data);
      }).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> uploadNewRestaurant(Restaurant restaurant) async {
    try {
      await _db.collection('restaurants').add(restaurant.toMap());
      await fetchCommunityRestaurants();
    } catch (e) {
      rethrow;
    }
  }
}

final communityProvider = StateNotifierProvider<CommunityRestaurantNotifier, AsyncValue<List<Restaurant>>>(
      (ref) => CommunityRestaurantNotifier(),
);