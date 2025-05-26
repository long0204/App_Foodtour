import 'dart:developer' as devtools show log;

import 'package:dio/dio.dart';

import '../utils/util.dart';

const warringANSI = '\x1b[101m\x1b[30mNULL\x1b[0m';

extension ObjExtension on Object? {
  bool get isNull => this == null;

  void log({String title = ''}) =>
      devtools.log('$title: ${this ?? warringANSI}');

  void logE([String title = '']) {
    if (runtimeType == DioException) {
      logger.e('err: $title: ${(this as DioException).response}');
      return;
    }
    logger.e('err: $title: $this');
  }
}
