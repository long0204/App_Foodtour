import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  
  Future<File?> compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      path,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    return result != null ? File(result.path) : null;
  }
}