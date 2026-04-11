import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/recommendation_result.dart';
import '../../../data/model/restaurant.dart';
import '../../../services/recommendation_service.dart';
import '../../../services/auth_service.dart';
import '../../../utils/logger.dart';

/// State cho recommendations
class RecommendationState {
  final List<RecommendationResult> recommendations;
  final bool isLoading;
  final String? error;

  RecommendationState({
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
  });

  RecommendationState copyWith({
    List<RecommendationResult>? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier cho recommendations
class RecommendationNotifier extends StateNotifier<RecommendationState> {
  final RecommendationService _recommendationService;
  final AuthService _authService;

  RecommendationNotifier(
    this._recommendationService,
    this._authService,
  ) : super(RecommendationState());

  /// Load recommendations cho user
  Future<void> loadRecommendations(List<Restaurant> allRestaurants) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = _authService.currentUser;
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not logged in',
        );
        return;
      }

      final recommendations = await _recommendationService.generateRecommendations(
        user.uid,
        allRestaurants,
        limit: 10,
      );

      state = state.copyWith(
        recommendations: recommendations,
        isLoading: false,
      );
    } catch (e) {
      devLog('Error loading recommendations: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh recommendations
  Future<void> refresh(List<Restaurant> allRestaurants) async {
    await loadRecommendations(allRestaurants);
  }

  /// Track khi user xem restaurant
  Future<void> trackView(Restaurant restaurant) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      await _recommendationService.trackRestaurantView(user.uid, restaurant);
      await _recommendationService.trackViewForTrending(restaurant.id ?? '');
    } catch (e) {
      devLog('Error tracking view: $e');
    }
  }

  /// Track khi user favorite restaurant
  Future<void> trackFavorite(Restaurant restaurant, bool isFavorite) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      await _recommendationService.trackRestaurantFavorite(
        user.uid,
        restaurant,
        isFavorite,
      );
    } catch (e) {
      devLog('Error tracking favorite: $e');
    }
  }
}

/// Provider cho recommendation notifier
final recommendationNotifierProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
  final recommendationService = ref.watch(recommendationServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return RecommendationNotifier(recommendationService, authService);
});

/// Provider cho trending restaurants
final trendingRestaurantsProvider = FutureProvider<List<RecommendationResult>>((ref) async {
  final recommendationService = ref.watch(recommendationServiceProvider);
  return await recommendationService.getTrendingRestaurants(limit: 10);
});
