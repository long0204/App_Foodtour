import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../data/model/favorite_address_model.dart';
import '../../favorite_address/providers/state.dart';
import 'state.dart';

final detailNotifierProvider = NotifierProvider<DetailNotifier, DetailState>(
  DetailNotifier.new,
);

class DetailNotifier extends Notifier<DetailState> {
  @override
  DetailState build() {
    return const DetailState(selectedItem: {});
  }

  void setSelectedItem(Map<String, dynamic> item) {
    state = DetailState(selectedItem: item);
  }

  Future<void> addFavoritePlace(WidgetRef ref, Map<String, dynamic> item) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    try{
      final place = FavoritePlace(
        name: item['Tên quán'],
        address: item['Địa chỉ'],
        type: item['Loại'] ?? 'Không có',
        price: item['Giá'] ?? '0.0',
      );
      var box = await Hive.openBox<FavoritePlace>('favorites');
      await box.add(place);
      await FirebaseFirestore.instance.collection('favorite_places').add({
        'name': place.name,
        'address': place.address,
        'type': place.type,
        'price': place.price,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ref.read(favoritePlacesProvider.notifier).loadFavoritePlaces();
      state = state.copyWith(isLoading: false);
    }
    catch (e, stackTrace) {
      state = state.copyWith(isLoading: false);
      debugPrint("❌ Lỗi lưu Firebase: $e");
      debugPrint("📍 StackTrace: $stackTrace");
    }
  }

  Future<void> submitRating({
    required double food,
    required double drink,
    required double ambiance,
    required String note,
    required Map<String, dynamic> place,
    required BuildContext context,
    required List<File> images,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      List<String> imageUrls = [];

      for (var image in images) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        final ref = FirebaseStorage.instance.ref().child('place_ratings/$fileName');
        final uploadTask = await ref.putFile(image);
        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final ratingData = {
        'placeId': place['id'],
        'food': food,
        'drink': drink,
        'ambiance': ambiance,
        'note': note,
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('place_ratings').add(ratingData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi đánh giá')),
        );
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Lỗi gửi đánh giá: $e");
      debugPrint("📍 StackTrace: $stackTrace");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


}
