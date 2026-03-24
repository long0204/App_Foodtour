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
  final String? reviewImageUrl;

  @HiveField(3)
  final double rating;

  @HiveField(4)
  final String comment;

  @HiveField(5)
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userName,
    this.reviewImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? 'Ẩn danh',
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
      'reviewImageUrl': reviewImageUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}