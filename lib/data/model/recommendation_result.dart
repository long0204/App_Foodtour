import '../data/model/restaurant.dart';

/// Model cho recommendation result
class RecommendationResult {
  final Restaurant restaurant;
  final double score; // Điểm recommendation (0-100)
  final String reason; // Lý do recommend
  final List<String> tags; // Tags: "trending", "friends_liked", "similar_to_favorites"

  RecommendationResult({
    required this.restaurant,
    required this.score,
    required this.reason,
    this.tags = const [],
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      restaurant: Restaurant.fromJson(json['restaurant']),
      score: (json['score'] ?? 0.0).toDouble(),
      reason: json['reason'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant': restaurant.toMap(),
      'score': score,
      'reason': reason,
      'tags': tags,
    };
  }
}
