
import 'package:flutter/material.dart';

import '../base/app_bar.dart';

class MySliverPersistentHeader extends StatelessWidget {
  const MySliverPersistentHeader(
      {required this.maxHeight,
      required this.minHeight,
      required this.child,
      this.pinned = false,
      super.key});
  final Widget child;
  final double minHeight, maxHeight;
  final bool pinned;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: pinned,
        delegate: SliverAppBarDelegate(
          minHeight: minHeight,
          maxHeight: maxHeight,
          child: child,
        ));
  }
}
