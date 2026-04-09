import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/api_client.dart';
import '../../../../data/model/review.dart';
import '../../../../services/cloudinary_service.dart';
import '../../../../services/image_service.dart';

part 'notifier.g.dart';

@riverpod
class RestaurantReviews extends _$RestaurantReviews {
  @override
  FutureOr<List<Review>> build(String restaurantId) async {
    return _fetchReviews();
  }

  Future<List<Review>> _fetchReviews() async {
    final response = await apiClient.get('/restaurants/$restaurantId/reviews');
    final List items = response as List;

    return items.map((e) => Review(
      id: e['id'] ?? '',
      userId: e['user_id'] ?? '',
      userName: e['profiles']?['fullname'] ?? 'Ẩn danh',
      rating: (e['rating'] as num?)?.toDouble() ?? 5.0,
      comment: e['comment'] ?? '',
      userAvatarUrl: e['profiles']?['avatar_url'],
      image_urls: e['image_urls'] != null ? List<String>.from(e['image_urls']) : [],
      createdAt: e['created_at'] != null ? DateTime.parse(e['created_at']) : DateTime.now(),
    )).toList();
  }

  Future<void> addReview({
    required double rating,
    required String comment,
    required List<File> images,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("Vui lòng đăng nhập để thực hiện chức năng này");
    }

    try {
      List<String> uploadedUrls = [];

      // 1. Nén và Upload ảnh (nếu có)
      if (images.isNotEmpty) {
        final imageUrls = await Future.wait(images.map((file) async {
          final compressed = await ImageService().compressImage(file);
          return await cloudinaryService.uploadImage(compressed ?? file);
        }));
        uploadedUrls = imageUrls.whereType<String>().toList();
      }

      // 2. Gọi API thêm đánh giá
      await apiClient.post(
        '/reviews',
        data: {
          "restaurant_id": restaurantId,
          "user_id": currentUser.uid,
          "rating": rating,
          "comment": comment,
          "image_urls": uploadedUrls,
        },
      );

      ref.invalidateSelf();
      await future;

    } catch (e) {
      throw Exception("Gửi đánh giá thất bại: $e");
    }
  }
}