import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../config/gen/assets.gen.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      this.imageUrl, {
        required this.height,
        required this.width,
        super.key,
        this.fit = BoxFit.cover,
        this.cacheH,
        this.cacheW,
        this.placeholder,
        this.errorWidget,
        this.fadeInDuration,
      });

  final String? imageUrl;
  final BoxFit fit;
  final double height;
  final double width;
  final double? cacheH;
  final double? cacheW;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration? fadeInDuration;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: errorWidget ?? placeholder ?? Assets.images.shared.placeholderImage.image(fit: fit),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      height: height,
      width: width,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
      memCacheHeight: cacheH?.ceil() ?? (height.isFinite ? (height * 2.5).ceil() : null),
      memCacheWidth: cacheW?.ceil() ?? (width.isFinite ? (width * 2.5).ceil() : null),
      errorWidget: (context, url, error) =>
      errorWidget ?? Assets.images.shared.placeholderImage.image(
          height: height,
          width: width,
          fit: fit
      ),
      placeholder: (context, url) =>
      placeholder ?? Container(color: Colors.grey[200], width: width, height: height),
    );
  }
}