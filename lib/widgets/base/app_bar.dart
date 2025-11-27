import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.child,
    this.decoration,
    super.key,
    this.h = kToolbarHeight,
  });
  final Widget child;
  final BoxDecoration? decoration;
  final double h;
  @override
  Size get preferredSize => Size.fromHeight(h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: decoration == null ? Colors.transparent : null,
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[child],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class SliverAppBarDelegateForTab3 extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  SliverAppBarDelegateForTab3(
      {required this.child, required this.maxHeight, required this.minHeight});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: const Color(0xFFF5F5F5),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegateForTab3 oldDelegate) {
    return false;
  }
}
