import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/favorite_address_model.dart';


class FavoritePlacesNotifier extends StateNotifier<List<FavoritePlace>> {
  FavoritePlacesNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load danh sách yêu thích từ Hive và Firebase
  Future<void> loadFavoritePlaces() async {
    var box = await Hive.openBox<FavoritePlace>('favorites');
    // Load dữ liệu từ Firebase
    QuerySnapshot snapshot = await _firestore.collection('favorite_places').get();

    // Duyệt qua các địa điểm từ Firebase và thêm vào Hive
    List<FavoritePlace> firebasePlaces = snapshot.docs.map((doc) {
      return FavoritePlace(
        name: doc['name'],
        address: doc['address'],
        type: doc['type'] ?? 'Không có',
        price: doc['price'] ?? '0.0',
      );
    }).toList();

    // Lấy dữ liệu từ Hive
    List<FavoritePlace> localPlaces = box.values.toList();

    state = List.from(Set<FavoritePlace>.from(localPlaces)..addAll(firebasePlaces));
  }

  Future<void> removeFavoritePlace(int index) async {
    var box = await Hive.openBox<FavoritePlace>('favorites');

    final place = box.getAt(index);

    await box.deleteAt(index);

    await _firestore.collection('favorite_places').where('address', isEqualTo: place?.address).get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // Cập nhật lại danh sách sau khi xóa
    loadFavoritePlaces();
  }

  Future<void> openGoogleMaps(BuildContext context, String address) async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?q=$address");
    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở Google Maps')),
      );
    }
  }

  void askForDirections(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'asset/lottie/quiz.json', // Đường dẫn đến file Lottie của bạn
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    const Gap( 20),
                    // Câu hỏi ở dưới animation
                    Text(
                      'Bạn có muốn tìm đường đến quán này trên Google Maps không?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.red.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            openGoogleMaps(context, address);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.green.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Có',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Đặt shadow cho container (nếu cần)
              Positioned(
                top: -40,
                left: 20,
                right: 20,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
