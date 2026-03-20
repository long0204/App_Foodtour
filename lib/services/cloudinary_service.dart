import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final String cloudName = "dg8r4xtl9";
  final String uploadPreset = "foodtour_preset";

  Future<String?> uploadImage(File imageFile) async {
    String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
        "upload_preset": uploadPreset,
        "folder": "restaurants",
      });

      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      }
    } catch (e) {
      print("Lỗi upload Cloudinary: $e");
    }
    return null;
  }
}

final cloudinaryService = CloudinaryService();