import 'package:hive/hive.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 0)
class Restaurant extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? type;

  @HiveField(4)
  String? price;

  Restaurant({required this.id, required this.name, required this.address, required this.type, required this.price});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['STT'].toString(),
      name: json['Tên quán'] ?? '',
      address: json['Địa chỉ'] ?? '',
      type: json['Loại'] ?? '',
      price: json['Giá'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "STT": id,
      "Loại": type,
      "Tên quán": name,
      "Địa chỉ": address,
      "Giá": price,
    };
  }
}
