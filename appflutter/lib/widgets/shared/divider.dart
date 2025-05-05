import 'package:flutter/material.dart';

import '../../config/themes/theme.dart';
import '../base/app_bar.dart';

class SliverDivider extends StatelessWidget {
  const SliverDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: false,
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 8,
        maxHeight: 8,
        child: Container(
          height: 8,
          width: double.maxFinite,
          color: grey100,
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
    this.height = 8,
    this.width = double.maxFinite,
    this.color = grey100,
  });
  final double height, width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
