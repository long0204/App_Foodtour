// lib/widgets/dialogs/loading_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../config/themes/text_style.dart';

/// Loading dialog
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    super.key,
    this.message = "Đang xử lý...",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 3,
            ),
            Gap(20.h),
            Text(
              message,
              style: k2d500.s14.grey600ts,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show loading dialog
Future<void> showLoadingDialog({
  required BuildContext context,
  String message = "Đang xử lý...",
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoadingDialog(message: message),
  );
}

/// Helper function to hide loading dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
