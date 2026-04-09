import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../services/location_service.dart';

part 'notifier.g.dart';

class RestaurantListState {
  final String searchQuery;
  final String? selectedCategory;
  final Position? userPosition;

  RestaurantListState({
    this.searchQuery = "",
    this.selectedCategory,
    this.userPosition,
  });

  RestaurantListState copyWith({
    String? searchQuery,
    String? Function()? selectedCategory,
    Position? userPosition,
  }) {
    return RestaurantListState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}

@riverpod
class RestaurantListNotifier extends _$RestaurantListNotifier {
  @override
  RestaurantListState build() {
    _fetchLocation();
    return RestaurantListState();
  }

  Future<void> _fetchLocation() async {
    try {
      final position = await locationService.getCurrentPosition();
      if (position != null) {
        state = state.copyWith(userPosition: position);
      }
    } catch (e) {
      print("Lỗi lấy GPS màn List: $e");
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
  }
}
