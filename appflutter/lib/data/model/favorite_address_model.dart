import 'package:hive/hive.dart';

part 'favorite_address_model.g.dart';

@HiveType(typeId: 1)
class FavoritePlace extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final String type;  // Loại quán (nhà hàng, quán cafe, v.v.)

  @HiveField(3)
  final String price; // Giá trung bì1nh

  FavoritePlace({
    required this.name,
    required this.address,
    required this.type,
    required this.price,
  });
}
