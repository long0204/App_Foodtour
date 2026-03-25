// File: lib/data/model/review.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart'; // Thêm import Hive

part 'review.g.dart'; // Khai báo file generate

@HiveType(typeId: 1) // Khai báo typeId cho Hive
class Review extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String? reviewImageUrl;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String comment;

  @HiveField(6)
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.userId,
    this.reviewImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? 'Ẩn danh',
      userId: json['userId'] ?? 'Ẩn danh',
      reviewImageUrl: json['reviewImageUrl'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
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
      'reviewImageUrl': reviewImageUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}