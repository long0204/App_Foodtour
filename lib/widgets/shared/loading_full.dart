import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.white.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withValues(alpha: 0.7),
          ),
          child: LoadingAnimationWidget.hexagonDots(
            color: color == null ? Colors.white : Colors.black,
            size: 55,
          ),
        ),
      ),
    );
  }
}
