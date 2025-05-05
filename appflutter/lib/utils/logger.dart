import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Số lượng hàm gọi sẽ được hiển thị
    errorMethodCount: 5, // Số lượng hàm gọi sẽ được hiển thị khi có lỗi
    lineLength: 50, // Số ký tự tối đa trên mỗi dòng
    colors: true, // Sử dụng màu sắc
    printEmojis: true, // Sử dụng emoji
    printTime: false, // Hiển thị thời gian
  ),
);

void devLog(Object? mess) {
  if (kDebugMode) dev.log('$mess');
}
