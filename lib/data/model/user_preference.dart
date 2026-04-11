import 'package:cloud_firestore/cloud_firestore.dart';

/// Model để lưu preferences của user
class UserPreference {
  final String userId;
  final List<String> favoriteCuisineTypes; // Loại món ăn yêu thích
  final List<String> favoritePriceRanges; // Khoảng giá yêu thích
  final double minRatingPreference; // Rating tối thiểu user thích
  final List<String> viewedRestaurantIds; // Danh sách quán đã xem
  final List<String> favoriteRestaurantIds; // Danh sách quán yêu thích
  final Map<String, int> cuisineTypeViews; // Số lần xem mỗi loại món
  final DateTime lastUpdated;

  UserPreference({
    required this.userId,
    this.favoriteCuisineTypes = const [],
    this.favoritePriceRanges = const [],
    this.minRatingPreference = 3.5,
    this.viewedRestaurantIds = const [],
    this.favoriteRestaurantIds = const [],
    this.cuisineTypeViews = const {},
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory UserPreference.fromJson(Map<String, dynamic> json) {
    return UserPreference(
      userId: json['userId'] ?? '',
      favoriteCuisineTypes: json['favoriteCuisineTypes'] != null
          ? List<String>.from(json['favoriteCuisineTypes'])
          : [],
      favoritePriceRanges: json['favoritePriceRanges'] != null
          ? List<String>.from(json['favoritePriceRanges'])
          : [],
      minRatingPreference: (json['minRatingPreference'] ?? 3.5).toDouble(),
      viewedRestaurantIds: json['viewedRestaurantIds'] != null
          ? List<String>.from(json['viewedRestaurantIds'])
          : [],
      favoriteRestaurantIds: json['favoriteRestaurantIds'] != null
          ? List<String>.from(json['favoriteRestaurantIds'])
          : [],
      cuisineTypeViews: json['cuisineTypeViews'] != null
          ? Map<String, int>.from(json['cuisineTypeViews'])
          : {},
      lastUpdated: json['lastUpdated'] != null
          ? (json['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'favoriteCuisineTypes': favoriteCuisineTypes,
      'favoritePriceRanges': favoritePriceRanges,
      'minRatingPreference': minRatingPreference,
      'viewedRestaurantIds': viewedRestaurantIds,
      'favoriteRestaurantIds': favoriteRestaurantIds,
      'cuisineTypeViews': cuisineTypeViews,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserPreference copyWith({
    String? userId,
    List<String>? favoriteCuisineTypes,
    List<String>? favoritePriceRanges,
    double? minRatingPreference,
    List<String>? viewedRestaurantIds,
    List<String>? favoriteRestaurantIds,
    Map<String, int>? cuisineTypeViews,
    DateTime? lastUpdated,
  }) {
    return UserPreference(
      userId: userId ?? this.userId,
      favoriteCuisineTypes: favoriteCuisineTypes ?? this.favoriteCuisineTypes,
      favoritePriceRanges: favoritePriceRanges ?? this.favoritePriceRanges,
      minRatingPreference: minRatingPreference ?? this.minRatingPreference,
      viewedRestaurantIds: viewedRestaurantIds ?? this.viewedRestaurantIds,
      favoriteRestaurantIds:
          favoriteRestaurantIds ?? this.favoriteRestaurantIds,
      cuisineTypeViews: cuisineTypeViews ?? this.cuisineTypeViews,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
