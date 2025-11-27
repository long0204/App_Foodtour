import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading(
      {required this.height,
      this.width = double.maxFinite,
      this.radius = 12,
      this.child,
      this.color = Colors.white,
      super.key});
  final double height;
  final double width;
  final double radius;
  final Widget? child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: child ??
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius), color: color),
          ),
    );
  }
}
