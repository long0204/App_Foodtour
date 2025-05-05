import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../config/themes/theme.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({this.size = 55, super.key});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.waveDots(
        color: primary,
        size: size,
      ),
    );
  }
}
