import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/l10n/l10n.dart';
import '../../config/themes/theme.dart';
import '../../core/route.dart';
import '../shared/loading_full.dart';
import '../shared/toast.dart';

class ShowManager {
  static ShowManager? _instance;

  ShowManager._();

  static ShowManager get instance => _instance ??= ShowManager._();

  void showToast(String msg,
      {bool isSuccess = false, bool multiLine = false, BuildContext? context}) {
    final FToast fToast = FToast().init(context ?? AppRouter.context!);
    fToast.removeCustomToast();
    fToast.showToast(
      child: ToastWidget(
        isMultiLine: multiLine,
        text: msg,
        bgColor: isSuccess ? Colors.green : Colors.redAccent,
        iconData: isSuccess ? Icons.check : Icons.warning,
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 3),
    );
  }

  void showSnackBar(String content,
      {BuildContext? context, void Function()? onPressed, String? label}) {
    final snackBar = SnackBar(
      backgroundColor: primary,
      behavior: SnackBarBehavior.floating,
      content: Text(content,),
      duration: const Duration(seconds: 4),
      action: onPressed == null
          ? null
          : SnackBarAction(
        label: label ?? '',
        onPressed: onPressed,
        textColor: Colors.white,
      ),
    );
    ScaffoldMessenger.of(context ?? AppRouter.context!).showSnackBar(snackBar);
  }


  // Future showSingleAlertDialog({
  //   required String title,
  //   required String content,
  //   BuildContext? context,
  //   Function()? onPressed,
  // }) {
  //   return showCupertinoDialog<void>(
  //     // useRootNavigator: true,
  //     context: context ?? AppRouter.context!,
  //     // barrierColor: Colors.black.withOpacity(0.2),
  //     builder: (BuildContext context) => Theme(
  //       data: ThemeData.light(),
  //       child: CupertinoAlertDialog(
  //         title: Text(title),
  //         content: Text(content),
  //         actions: <CupertinoDialogAction>[
  //           CupertinoDialogAction(
  //             isDestructiveAction: true,
  //             onPressed: onPressed ?? pop,
  //             child: Text(
  //               AppLocalizations.of(context)!.close,
  //               style: k2d500.primaryFFts,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Future showAlertDialog({
  //   required String title,
  //   required String content,
  //   required String rTxt,
  //   String? leftTxt,
  //   TextStyle? lStyle,
  //   TextStyle? rStyle,
  //   void Function() onPressedR = pop,
  //   void Function() onPressedL = pop,
  //   BuildContext? context,
  //   bool barrierDismissible = true,
  // }) {
  //   return showCupertinoDialog<void>(
  //     // useRootNavigator: true,
  //     barrierDismissible: barrierDismissible,
  //     context: context ?? AppRouter.context!,
  //     // barrierColor: Colors.black.withOpacity(0.2),
  //     builder: (BuildContext _) => Theme(
  //       data: ThemeData.light(),
  //       child: CupertinoAlertDialog(
  //         title: Text(title),
  //         content: Text(content),
  //         actions: <CupertinoDialogAction>[
  //           leftTxt == null
  //               ? CupertinoDialogAction(
  //             isDestructiveAction: true,
  //             onPressed: pop,
  //             child: Text(
  //               AppLocalizations.of(context ?? AppRouter.context!)!
  //                   .cancel,
  //             ),
  //           )
  //               : CupertinoDialogAction(
  //             isDestructiveAction: false,
  //             onPressed: onPressedL,
  //             child: Text(leftTxt, style: lStyle ?? k2d500.primaryFFts),
  //           ),
  //           CupertinoDialogAction(
  //             isDestructiveAction: false,
  //             onPressed: onPressedR,
  //             child: Text(rTxt, style: rStyle ?? k2d500.primaryFFts),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> showFullscreenLoadingDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, a, s) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const LoadingFullScreen(),
        );
      },
    );
  }

  Future showForceUpdateDialog({
    BuildContext? context,
    Function()? onPressed,
  }) {
    return showCupertinoDialog<void>(
      context: context ?? AppRouter.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => Theme(
        data: ThemeData.light(),
        child: CupertinoAlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Vui lòng cập nhật ứng dụng để tiếp tục sử dụng.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: onPressed,
              child: Text(
                'Cập nhật',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: grey900,
                    fontSize: 16,
                    letterSpacing: -0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showAlertDialog({
    required String title,
    required String content,
    required String rTxt,
    String? leftTxt,
    TextStyle? lStyle,
    TextStyle? rStyle,
    void Function() onPressedR = pop,
    void Function() onPressedL = pop,
    BuildContext? context,
    bool barrierDismissible = true,
  }) {
    return showCupertinoDialog<void>(
      // useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      context: context ?? AppRouter.context!,
      // barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext _) => Theme(
        data: ThemeData.light(),
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <CupertinoDialogAction>[
            leftTxt == null
                ? CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: pop,
              child: Text(
                  'Huỷ'
              ),
            )
                : CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: onPressedL,
              child: Text(leftTxt, style: lStyle ?? TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: grey900,
                  fontSize: 16,
                  letterSpacing: -0.05)),
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: onPressedR,
              child: Text(rTxt, style: rStyle ?? TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: grey900,
                  fontSize: 16,
                  letterSpacing: -0.05)),
            ),
          ],
        ),
      ),
    );
  }

}

final showManager = ShowManager.instance;
