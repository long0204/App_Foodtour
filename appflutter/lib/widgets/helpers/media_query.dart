import 'package:flutter/material.dart';

class MediaQueryUtil {
  static late Size _size;
  static late EdgeInsets _padding;

  static void init(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    _padding = MediaQuery.paddingOf(context);
  }
}

Size get mqSize => MediaQueryUtil._size;
EdgeInsets get mqPadding => MediaQueryUtil._padding;
