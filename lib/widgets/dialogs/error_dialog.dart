// lib/widgets/dialogs/error_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/themes/text_style.dart';
import 'common_dialog.dart';

/// Error dialog
class ErrorDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    this.title,
    required this.message,
    this.buttonText = "Đóng",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title ?? "Lỗi",
      message: message,
      icon: Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
      iconColor: Colors.red,
      actions: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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

/// Helper function to show error dialog
Future<void> showErrorDialog({
  required BuildContext context,
  String? title,
  required String message,
  String buttonText = "Đóng",
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    ),
  );
}
