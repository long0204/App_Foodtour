import 'package:flutter/material.dart';

class ContainerMultiGradient extends StatelessWidget {
  const ContainerMultiGradient({
    required this.borderGradient,
    required this.backgroundGradient,
    required this.child,
    this.borderColor,
    this.stops,
    this.margin,
    this.padding,
    super.key,
  });

  final Widget child;
  final Gradient? borderGradient;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final List<double>? stops;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 1),
        gradient: borderGradient,
      ),
      child: Container(
        padding: padding,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: backgroundGradient,
        ),
        child: child,
      ),
    );
  }
}
