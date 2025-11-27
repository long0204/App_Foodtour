// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // Apply ClampingScrollPhysics
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final double scrollFriction;

  const CustomScrollPhysics({super.parent, this.scrollFriction = 0.02});

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
        parent: buildParent(ancestor), scrollFriction: scrollFriction);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset; // giữ nguyên offset, không thay đổi tốc độ cuộn trực tiếp
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Giảm tốc độ cuộn dựa trên scrollFriction
    if (velocity.abs() < tolerance.velocity) return null;
    return FrictionSimulation(
      scrollFriction,
      position.pixels,
      velocity,
      tolerance: tolerance,
    );
  }
}
