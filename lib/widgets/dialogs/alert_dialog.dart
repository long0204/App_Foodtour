// lib/widgets/dialogs/alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/themes/text_style.dart';
import 'common_dialog.dart';

/// Alert/Info dialog
class AlertDialogCustom extends StatelessWidget {
  final String? title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const AlertDialogCustom({
    super.key,
    this.title,
    required this.message,
    this.buttonText = "OK",
    this.onPressed,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title ?? "Thông báo",
      message: message,
      icon: Icon(
        icon ?? Icons.info_outline,
        size: 64.sp,
        color: iconColor ?? Colors.blue,
      ),
      iconColor: iconColor ?? Colors.blue,
      actions: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor ?? Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText, style: k2d600.s14.white),
          ),
        ),
      ],
    );
  }
}

/// Helper function to show alert dialog
Future<void> showAlertDialog({
  required BuildContext context,
  String? title,
  required String message,
  String buttonText = "OK",
  VoidCallback? onPressed,
  IconData? icon,
  Color? iconColor,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialogCustom(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: icon,
      iconColor: iconColor,
    ),
  );
}
