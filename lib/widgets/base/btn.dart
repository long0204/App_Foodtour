import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../config/themes/color.dart';

class ZoomTap extends StatelessWidget {
  const ZoomTap({
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

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 44,
    this.isLoading = false,
    this.enable = true,
    this.textStyle,
    this.prefixIcon,
  });
  final String text;
  final VoidCallback onPressed;
  final double? width, height;
  final bool isLoading;
  final bool enable;
  final TextStyle? textStyle;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final isActive = (enable && !isLoading);
    return ZoomTap(
      onTap: isActive ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      primaryFF.withOpacity(1),
                      primaryB5,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const [0.05, 0.9])
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 6,
                    ),
                  ]
                : [],
            borderRadius: BorderRadius.circular(40),
            color: isActive ? null : primaryB5.withOpacity(0.4)),
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.prograssiveDots(color: white, size: 40)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: textStyle),
                    if (prefixIcon != null)
                      Padding(
                          padding: const EdgeInsets.only(left: 5), child: prefixIcon!)
                  ],
                ),
        ),
      ),
    );
  }
}

class TransButton extends StatelessWidget {
  const TransButton({
    required this.text,
    super.key,
    this.onPressed,
    this.width = double.maxFinite,
    this.height = 44,
    this.style,
    this.colorSide = primaryB5,
    this.isLoading = false,
  });
  final String text;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final TextStyle? style;
  final Color colorSide;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ZoomTap(
      onTap: onPressed,
      child: TextButton(
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: colorSide)),
          onPressed: onPressed,
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: isLoading
                  ? LoadingAnimationWidget.waveDots(
                      color: colorSide,
                      size: 40,
                    )
                  : Text(
                      text,
                      style: style,
                    ),
            ),
          )),
    );
  }
}
