// lib/widgets/dialogs/success_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../config/themes/text_style.dart';
import 'common_dialog.dart';

/// Success dialog với animation
class SuccessDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    super.key,
    this.title,
    required this.message,
    this.buttonText = "OK",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title ?? "Thành công",
      message: message,
      icon: Icon(Icons.check_circle, size: 64.sp, color: Colors.green),
      iconColor: Colors.green,
      actions: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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

/// Helper function to show success dialog
Future<void> showSuccessDialog({
  required BuildContext context,
  String? title,
  required String message,
  String buttonText = "OK",
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) => SuccessDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    ),
  );
}
