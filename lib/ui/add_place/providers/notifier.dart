import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/api_client_provider.dart';
import '../../../../data/sources/remote/google_service.dart';
import '../../../../providers/community_provider.dart';
import '../../../../services/cloudinary_service.dart';
import '../../../../services/image_service.dart';

part 'notifier.g.dart';

@riverpod
class AddPlaceNotifier extends _$AddPlaceNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submitPlace({
    required String name,
    required String address,
    required String price,
    required String description,
    required String type,
    required List<File> images,
  }) async {
    state = const AsyncLoading();

    try {
      final imageService = ImageService();
      List<File> compressedFiles = [];

      // 1. Nén ảnh
      for (final file in images) {
        final compressed = await imageService.compressImage(file);
        compressedFiles.add(compressed ?? file);
      }

      // 2. Upload ảnh lên Cloudinary
      final imageUrls = await Future.wait(
          compressedFiles.map((file) => cloudinaryService.uploadImage(file)));
      final finalImageUrls = imageUrls.whereType<String>().toList();

      // 3. Lấy tọa độ từ địa chỉ (Geocoding)
      final coords = await getCoordinatesFromAddress(address);

      // 4. Bắn API lưu vào Database
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        '/restaurants',
        data: {
          "name": name,
          "address": address,
          "type": type,
          "price": price,
          "description": description,
          "image_urls": finalImageUrls, // Hợp lệ kể cả khi mảng rỗng []
          "lat": coords?.latitude,
          "lng": coords?.longitude,
        },
      );

      // 5. Cập nhật lại các danh sách gợi ý và cộng đồng
      if (coords != null) {
        ref
            .read(suggestionProvider.notifier)
            .fetchSuggestions(coords.latitude, coords.longitude);
        ref.read(communityProvider.notifier).fetchAllRestaurants();
      }

      // Tắt trạng thái loading (thành công)
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      // Báo lỗi
      state = AsyncError(e, stackTrace);
      throw Exception("Không thể thêm quán: $e");
    }
  }
}
