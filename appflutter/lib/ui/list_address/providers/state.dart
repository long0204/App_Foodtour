import 'package:equatable/equatable.dart';
import '../../../data/model/restaurant.dart';

class RestaurantState extends Equatable {
  final List<Restaurant> allRestaurants;
  final List<Restaurant> filteredRestaurants;
  final String? selectedType;
  final bool isLoading;

  const RestaurantState({
    required this.allRestaurants,
    required this.filteredRestaurants,
    this.selectedType,
    this.isLoading = false,
  });

  RestaurantState copyWith({
    List<Restaurant>? allRestaurants,
    List<Restaurant>? filteredRestaurants,
    String? selectedType,
    bool? isLoading,
  }) {
    return RestaurantState(
      allRestaurants: allRestaurants ?? this.allRestaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [allRestaurants, filteredRestaurants, selectedType, isLoading];
}
