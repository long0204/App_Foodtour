import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../data/model/restaurant.dart';
import '../utils/logger.dart';

/// Service để share content lên social media
class ShareService {
  final ScreenshotController _screenshotController = ScreenshotController();

  ScreenshotController get screenshotController => _screenshotController;

  /// Share restaurant với text và link
  Future<void> shareRestaurant(
    Restaurant restaurant, {
    String? customMessage,
  }) async {
    try {
      final message = customMessage ??
          '🍽️ ${restaurant.name}\n'
          '📍 ${restaurant.address}\n'
          '⭐ ${restaurant.rating}/5.0\n'
          '💰 ${restaurant.price}\n'
          '🏷️ ${restaurant.type}\n\n'
          'Tải FoodTour để khám phá thêm nhiều quán ngon!';

      await Share.share(
        message,
        subject: 'Gợi ý quán ăn từ FoodTour',
      );
    } catch (e) {
      devLog('Error sharing restaurant: $e');
      rethrow;
    }
  }

  /// Share restaurant với image (screenshot của card)
  Future<void> shareRestaurantWithImage(
    Restaurant restaurant,
    Widget shareCard, {
    String? customMessage,
  }) async {
    try {
      // Capture screenshot
      final imageBytes = await _screenshotController.captureFromWidget(
        shareCard,
        delay: const Duration(milliseconds: 100),
      );

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      final message = customMessage ??
          '🍽️ ${restaurant.name}\n'
          '📍 ${restaurant.address}\n'
          '⭐ ${restaurant.rating}/5.0\n\n'
          'Tải FoodTour để khám phá thêm!';

      // Share with image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: 'Gợi ý quán ăn từ FoodTour',
      );

      // Clean up
      await file.delete();
    } catch (e) {
      devLog('Error sharing restaurant with image: $e');
      rethrow;
    }
  }

  /// Share review
  Future<void> shareReview(
    Restaurant restaurant,
    String reviewText,
    double rating,
  ) async {
    try {
      final message = '⭐ ${rating.toStringAsFixed(1)}/5.0\n\n'
          '"$reviewText"\n\n'
          '📍 ${restaurant.name}\n'
          '${restaurant.address}\n\n'
          'Review từ FoodTour';

      await Share.share(
        message,
        subject: 'Review quán ăn từ FoodTour',
      );
    } catch (e) {
      devLog('Error sharing review: $e');
      rethrow;
    }
  }

  /// Share to specific platform
  Future<void> shareToSpecificPlatform(
    String message,
    String platform, {
    List<String>? imagePaths,
  }) async {
    try {
      // Note: share_plus doesn't support platform-specific sharing directly
      // We'll use the general share which shows platform picker
      if (imagePaths != null && imagePaths.isNotEmpty) {
        await Share.shareXFiles(
          imagePaths.map((path) => XFile(path)).toList(),
          text: message,
        );
      } else {
        await Share.share(message);
      }
    } catch (e) {
      devLog('Error sharing to $platform: $e');
      rethrow;
    }
  }

  /// Generate deep link for restaurant
  String generateRestaurantDeepLink(Restaurant restaurant) {
    // TODO: Replace with actual deep link domain
    final restaurantId = restaurant.id ?? '';
    return 'https://foodtour.app/restaurant/$restaurantId';
  }

  /// Share with deep link
  Future<void> shareRestaurantWithDeepLink(Restaurant restaurant) async {
    try {
      final deepLink = generateRestaurantDeepLink(restaurant);
      final message = '🍽️ ${restaurant.name}\n'
          '📍 ${restaurant.address}\n'
          '⭐ ${restaurant.rating}/5.0\n\n'
          'Xem chi tiết: $deepLink';

      await Share.share(message);
    } catch (e) {
      devLog('Error sharing with deep link: $e');
      rethrow;
    }
  }

  /// Check if sharing is available
  Future<bool> canShare() async {
    try {
      // share_plus is available on all platforms
      return true;
    } catch (e) {
      devLog('Error checking share availability: $e');
      return false;
    }
  }
}

// Provider
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});
