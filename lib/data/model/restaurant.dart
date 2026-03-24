import 'package:hive/hive.dart';
import 'review.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 0)
class Restaurant extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String price;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final List<String> imageUrls;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final List<Review>? reviews;

  @HiveField(9)
  final double? latitude;

  @HiveField(10)
  final double? longitude;

  Restaurant({
    this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.price,
    required this.rating,
    required this.imageUrls,
    this.description,
    this.reviews,
    this.latitude,
    this.longitude,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      type: json['Loại'] ?? '',
      name: json['Tên quán'] ?? '',
      address: json['Địa chỉ'] ?? '',
      price: json['Giá'] ?? '',
      rating: (json['Rating'] ?? 0.0).toDouble(),
      imageUrls: json['Images'] != null ? List<String>.from(json['Images']) : [],
      description: json['Mô tả'],
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : [],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Tên quán': name,
      'Địa chỉ': address,
      'Loại': type,
      'Giá': price,
      'Rating': rating,
      'Images': imageUrls,
      'Mô tả': description,
      'reviews': reviews?.map((x) => x.toMap()).toList() ?? [],
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}