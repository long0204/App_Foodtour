import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'review.g.dart';

@HiveType(typeId: 1)
class Review extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String? userAvatarUrl;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String comment;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final List<String>? image_urls;

  Review({
    required this.id,
    required this.userName,
    required this.userId,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.image_urls,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? 'Ẩn danh',
      userId: json['userId'] ?? 'Ẩn danh',
      userAvatarUrl: json['reviewImageUrl'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      image_urls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userId': userId,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'image_urls': image_urls,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}