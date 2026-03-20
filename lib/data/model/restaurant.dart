import 'package:hive/hive.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 0)
class Restaurant extends HiveObject {
  @HiveField(0) String? id;
  @HiveField(1) String? name;
  @HiveField(2) String? address;
  @HiveField(3) String? type;
  @HiveField(4) String? price;
  @HiveField(5) double? rating;
  @HiveField(6) List<String>? imageUrls;
  @HiveField(7) String? createdBy;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.price,
    this.rating = 0.0,
    this.imageUrls,
    this.createdBy,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['STT']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['Tên quán'] ?? '',
      address: json['Địa chỉ'] ?? '',
      type: json['Loại'] ?? '',
      price: json['Giá'] ?? '',
      rating: double.tryParse(json['Rating']?.toString() ?? '0.0') ?? 0.0,
      imageUrls: json['Images'] != null ? List<String>.from(json['Images']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Tên quán': name,
      'Địa chỉ': address,
      'Loại': type,
      'Giá': price,
      'Rating': rating,
      'Images': imageUrls,
      'createdBy': createdBy,
    };
  }
}