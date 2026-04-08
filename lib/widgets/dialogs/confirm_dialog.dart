// lib/widgets/dialogs/confirm_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/themes/text_style.dart';
import 'common_dialog.dart';

/// Confirmation dialog với Yes/No buttons
class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final Color cancelColor;

  const ConfirmDialog({
    super.key,
    this.title,
    required this.message,
    this.confirmText = "Xác nhận",
    this.cancelText = "Hủy",
    this.onConfirm,
    this.onCancel,
    this.confirmColor = Colors.red,
    this.cancelColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title ?? "Xác nhận",
      message: message,
      icon: Icon(Icons.help_outline, size: 48.sp, color: Colors.orange),
      iconColor: Colors.orange,
      actions: [
        // Cancel button
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: cancelColor,
              side: BorderSide(color: cancelColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText, style: k2d500.s14),
          ),
        ),
        SizedBox(width: 12.w),
        // Confirm button
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText, style: k2d600.s14.white),
          ),
        ),
      ],
    );
  }
}

/// Helper function to show confirm dialog
Future<bool?> showConfirmDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = "Xác nhận",
  String cancelText = "Hủy",
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  Color confirmColor = Colors.red,
  Color cancelColor = Colors.grey,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmColor: confirmColor,
      cancelColor: cancelColor,
    ),
  );
}
