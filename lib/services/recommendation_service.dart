import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/restaurant.dart';
import '../data/model/user_preference.dart';
import '../data/model/recommendation_result.dart';
import '../utils/logger.dart';
import 'firebase_core.dart';

/// Service để tạo recommendations cho user
class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await firebaseCore.init();
    _initialized = true;
  }

  /// Lấy user preferences từ Firestore
  Future<UserPreference?> getUserPreferences(String userId) async {
    try {
      await init();
      final doc = await _firestore
          .collection('user_preferences')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserPreference.fromJson(doc.data()!);
      }
      
      // Nếu chưa có preferences, tạo mới
      return UserPreference(userId: userId);
    } catch (e) {
      devLog('Error getting user preferences: $e');
      return null;
    }
  }

  /// Lưu user preferences
  Future<void> saveUserPreferences(UserPreference preferences) async {
    try {
      await init();
      await _firestore
          .collection('user_preferences')
          .doc(preferences.userId)
          .set(preferences.toJson());
    } catch (e) {
      devLog('Error saving user preferences: $e');
    }
  }

  /// Track khi user xem restaurant
  Future<void> trackRestaurantView(
    String userId,
    Restaurant restaurant,
  ) async {
    try {
      final prefs = await getUserPreferences(userId);
      if (prefs == null) return;

      // Update viewed restaurants
      final viewedIds = List<String>.from(prefs.viewedRestaurantIds);
      if (restaurant.id != null && !viewedIds.contains(restaurant.id)) {
        viewedIds.add(restaurant.id!);
      }

      // Update cuisine type views
      final cuisineViews = Map<String, int>.from(prefs.cuisineTypeViews);
      cuisineViews[restaurant.type] = (cuisineViews[restaurant.type] ?? 0) + 1;

      // Update preferences
      final updatedPrefs = prefs.copyWith(
        viewedRestaurantIds: viewedIds,
        cuisineTypeViews: cuisineViews,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferences(updatedPrefs);
    } catch (e) {
      devLog('Error tracking restaurant view: $e');
    }
  }

  /// Track khi user favorite restaurant
  Future<void> trackRestaurantFavorite(
    String userId,
    Restaurant restaurant,
    bool isFavorite,
  ) async {
    try {
      final prefs = await getUserPreferences(userId);
      if (prefs == null) return;

      final favoriteIds = List<String>.from(prefs.favoriteRestaurantIds);
      
      if (isFavorite && restaurant.id != null) {
        if (!favoriteIds.contains(restaurant.id)) {
          favoriteIds.add(restaurant.id!);
        }
      } else {
        favoriteIds.remove(restaurant.id);
      }

      // Update favorite cuisine types
      final favoriteCuisines = List<String>.from(prefs.favoriteCuisineTypes);
      if (isFavorite && !favoriteCuisines.contains(restaurant.type)) {
        favoriteCuisines.add(restaurant.type);
      }

      // Update favorite price ranges
      final favoritePrices = List<String>.from(prefs.favoritePriceRanges);
      if (isFavorite && !favoritePrices.contains(restaurant.price)) {
        favoritePrices.add(restaurant.price);
      }

      final updatedPrefs = prefs.copyWith(
        favoriteRestaurantIds: favoriteIds,
        favoriteCuisineTypes: favoriteCuisines,
        favoritePriceRanges: favoritePrices,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferences(updatedPrefs);
    } catch (e) {
      devLog('Error tracking restaurant favorite: $e');
    }
  }

  /// Tính similarity score giữa 2 restaurants
  double _calculateSimilarity(
    Restaurant r1,
    Restaurant r2,
    UserPreference prefs,
  ) {
    double score = 0.0;

    // Same cuisine type (40 points)
    if (r1.type == r2.type) {
      score += 40.0;
    }

    // Same price range (20 points)
    if (r1.price == r2.price) {
      score += 20.0;
    }

    // Similar rating (20 points)
    final ratingDiff = (r1.rating - r2.rating).abs();
    if (ratingDiff <= 0.5) {
      score += 20.0;
    } else if (ratingDiff <= 1.0) {
      score += 10.0;
    }

    // Bonus if matches user preferences (20 points)
    if (prefs.favoriteCuisineTypes.contains(r1.type)) {
      score += 10.0;
    }
    if (prefs.favoritePriceRanges.contains(r1.price)) {
      score += 10.0;
    }

    return score;
  }

  /// Generate recommendations cho user
  Future<List<RecommendationResult>> generateRecommendations(
    String userId,
    List<Restaurant> allRestaurants, {
    int limit = 10,
  }) async {
    try {
      final prefs = await getUserPreferences(userId);
      if (prefs == null) {
        // Nếu chưa có preferences, return popular restaurants
        return _getPopularRestaurants(allRestaurants, limit);
      }

      final recommendations = <RecommendationResult>[];

      // Get favorite restaurants
      final favoriteRestaurants = allRestaurants
          .where((r) => prefs.favoriteRestaurantIds.contains(r.id))
          .toList();

      for (final restaurant in allRestaurants) {
        // Skip if already viewed or favorited
        if (prefs.viewedRestaurantIds.contains(restaurant.id) ||
            prefs.favoriteRestaurantIds.contains(restaurant.id)) {
          continue;
        }

        // Skip if rating too low
        if (restaurant.rating < prefs.minRatingPreference) {
          continue;
        }

        double totalScore = 0.0;
        String reason = '';
        final tags = <String>[];

        // Calculate similarity with favorite restaurants
        if (favoriteRestaurants.isNotEmpty) {
          double maxSimilarity = 0.0;
          for (final fav in favoriteRestaurants) {
            final similarity = _calculateSimilarity(restaurant, fav, prefs);
            if (similarity > maxSimilarity) {
              maxSimilarity = similarity;
            }
          }
          totalScore += maxSimilarity;
          
          if (maxSimilarity > 50) {
            reason = 'Tương tự quán bạn yêu thích';
            tags.add('similar_to_favorites');
          }
        }

        // Bonus for favorite cuisine type
        if (prefs.favoriteCuisineTypes.contains(restaurant.type)) {
          totalScore += 15.0;
          if (reason.isEmpty) {
            reason = 'Món ${restaurant.type} bạn thích';
          }
        }

        // Bonus for favorite price range
        if (prefs.favoritePriceRanges.contains(restaurant.price)) {
          totalScore += 10.0;
        }

        // Bonus for high rating
        if (restaurant.rating >= 4.5) {
          totalScore += 10.0;
          tags.add('high_rated');
        }

        // Bonus for many reviews
        if (restaurant.reviews != null && restaurant.reviews!.length >= 10) {
          totalScore += 5.0;
          tags.add('popular');
        }

        if (totalScore > 0) {
          recommendations.add(RecommendationResult(
            restaurant: restaurant,
            score: totalScore,
            reason: reason.isEmpty ? 'Gợi ý cho bạn' : reason,
            tags: tags,
          ));
        }
      }

      // Sort by score descending
      recommendations.sort((a, b) => b.score.compareTo(a.score));

      // Return top N
      return recommendations.take(limit).toList();
    } catch (e) {
      devLog('Error generating recommendations: $e');
      return [];
    }
  }

  /// Get popular restaurants (fallback khi chưa có preferences)
  List<RecommendationResult> _getPopularRestaurants(
    List<Restaurant> restaurants,
    int limit,
  ) {
    final sorted = List<Restaurant>.from(restaurants);
    sorted.sort((a, b) {
      // Sort by rating first
      final ratingCompare = b.rating.compareTo(a.rating);
      if (ratingCompare != 0) return ratingCompare;
      
      // Then by number of reviews
      final aReviews = a.reviews?.length ?? 0;
      final bReviews = b.reviews?.length ?? 0;
      return bReviews.compareTo(aReviews);
    });

    return sorted.take(limit).map((r) => RecommendationResult(
      restaurant: r,
      score: r.rating * 10,
      reason: 'Quán phổ biến',
      tags: ['popular'],
    )).toList();
  }

  /// Get trending restaurants (most viewed in last 24h)
  Future<List<RecommendationResult>> getTrendingRestaurants({
    int limit = 10,
  }) async {
    try {
      await init();
      
      final yesterday = DateTime.now().subtract(const Duration(hours: 24));
      
      // Query restaurant views in last 24h
      final viewsSnapshot = await _firestore
          .collection('restaurant_views')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(yesterday))
          .get();

      // Count views per restaurant
      final viewCounts = <String, int>{};
      for (final doc in viewsSnapshot.docs) {
        final restaurantId = doc.data()['restaurantId'] as String?;
        if (restaurantId != null) {
          viewCounts[restaurantId] = (viewCounts[restaurantId] ?? 0) + 1;
        }
      }

      // Sort by view count
      final sortedIds = viewCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Get restaurant details
      final results = <RecommendationResult>[];
      for (final entry in sortedIds.take(limit)) {
        final restaurantDoc = await _firestore
            .collection('restaurants')
            .doc(entry.key)
            .get();
        
        if (restaurantDoc.exists && restaurantDoc.data() != null) {
          final restaurant = Restaurant.fromJson(restaurantDoc.data()!);
          results.add(RecommendationResult(
            restaurant: restaurant,
            score: entry.value.toDouble(),
            reason: 'Đang hot hôm nay',
            tags: ['trending'],
          ));
        }
      }

      return results;
    } catch (e) {
      devLog('Error getting trending restaurants: $e');
      return [];
    }
  }

  /// Track restaurant view for trending calculation
  Future<void> trackViewForTrending(String restaurantId) async {
    try {
      await init();
      await _firestore.collection('restaurant_views').add({
        'restaurantId': restaurantId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      devLog('Error tracking view for trending: $e');
    }
  }
}

// Provider
final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService();
});
