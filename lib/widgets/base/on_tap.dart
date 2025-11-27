import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MyInkWell extends StatelessWidget {
  const MyInkWell({
    required this.onTap,
    required this.child,
    super.key,
  });
  final Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}

class OnTapWidget extends StatelessWidget {
  const OnTapWidget({
    required this.onTap,
    required this.child,
    super.key,
  });
  final Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
