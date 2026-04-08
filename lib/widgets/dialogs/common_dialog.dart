// lib/widgets/dialogs/common_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../config/themes/text_style.dart';

/// Base dialog widget với design đồng nhất
class CommonDialog extends StatelessWidget {
  final String? title;
  final String message;
  final Widget? icon;
  final Color? iconColor;
  final List<Widget>? actions;
  final bool barrierDismissible;

  const CommonDialog({
    super.key,
    this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.actions,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon (if provided)
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.red).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: icon!,
              ),
              Gap(16.h),
            ],

            // Title (if provided)
            if (title != null) ...[
              Text(
                title!,
                style: k2d600.s20,
                textAlign: TextAlign.center,
              ),
              Gap(12.h),
            ],

            // Message
            Text(
              message,
              style: k2d400.s14.grey600ts,
              textAlign: TextAlign.center,
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              Gap(24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Helper function to show common dialog
Future<T?> showCommonDialog<T>({
  required BuildContext context,
  String? title,
  required String message,
  Widget? icon,
  Color? iconColor,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CommonDialog(
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
      actions: actions,
      barrierDismissible: barrierDismissible,
    ),
  );
}
