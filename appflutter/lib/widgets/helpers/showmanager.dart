// import 'dart:io';
//
// import 'package:app_settings/app_settings.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ting_x/widgets/shared/loading_full.dart';
//
// import '../../config/l10n/l10n.dart';
// import '../../config/themes/theme.dart';
// import '../../core/router.dart';
// import '../shared/loading_full.dart';
// import '../shared/toast.dart';
// import '../../utils/helpers/picker.dart';
//
// class ShowManager {
//   static ShowManager? _instance;
//
//   ShowManager._();
//
//   static ShowManager get instance => _instance ??= ShowManager._();
//
//   void showToast(String msg,
//       {bool isSuccess = false, bool multiLine = false, BuildContext? context}) {
//     final FToast fToast = FToast().init(context ?? AppRouter.context!);
//     fToast.removeCustomToast();
//     fToast.showToast(
//       child: ToastWidget(
//         isMultiLine: multiLine,
//         text: msg,
//         bgColor: isSuccess ? Colors.green : Colors.redAccent,
//         iconData: isSuccess ? Icons.check : Icons.warning,
//       ),
//       gravity: ToastGravity.TOP,
//       toastDuration: const Duration(seconds: 3),
//     );
//   }
//
//   void showSnackBar(String content,
//       {BuildContext? context, void Function()? onPressed, String? label}) {
//     final snackBar = SnackBar(
//       backgroundColor: primary,
//       behavior: SnackBarBehavior.floating,
//       content: Text(content, style: k2d400.white),
//       duration: const Duration(seconds: 4),
//       action: onPressed == null
//           ? null
//           : SnackBarAction(
//         label: label ?? '',
//         onPressed: onPressed,
//         textColor: Colors.white,
//       ),
//     );
//     ScaffoldMessenger.of(context ?? AppRouter.context!).showSnackBar(snackBar);
//   }
//
//   Future<void> showImageActionSheet({
//     required Function(File file) onPicked,
//     String title = '',
//     BuildContext? context,
//   }) async {
//     final l10n = AppLocalizations.of(context ?? AppRouter.context!)!;
//
//     showCupertinoModalPopup<void>(
//       context: context ?? AppRouter.context!,
//       builder: (BuildContext context) => CupertinoTheme(
//         data: const CupertinoThemeData(
//             brightness: Brightness.light,
//             scaffoldBackgroundColor: Colors.white),
//         child: CupertinoActionSheet(
//           // message: title.isEmpty ? null : Text(title, style: k2d500.grey600),
//           actions: <CupertinoActionSheetAction>[
//             CupertinoActionSheetAction(
//               onPressed: () async {
//                 final access =
//                 await imgPicker.permissionCamera(ImageSource.camera);
//                 if (!access) {
//                   showAlertDialog(
//                     title: l10n.noti,
//                     content: l10n.plsGrantPermission,
//                     rTxt: l10n.setting,
//                     onPressedR: () {
//                       AppSettings.openAppSettings(
//                           type: AppSettingsType.settings);
//                     },
//                   );
//                   return;
//                 }
//                 final file = await imgPicker.getImage(ImageSource.camera);
//                 if (file != null) {
//                   onPicked(file);
//                 }
//                 pop();
//               },
//               child: const Text('Camera'),
//             ),
//             CupertinoActionSheetAction(
//               onPressed: () async {
//                 final access =
//                 await imgPicker.permissionCamera(ImageSource.gallery);
//                 if (!access) {
//                   showAlertDialog(
//                     title: l10n.noti,
//                     content: l10n.plsGrantPermission,
//                     rTxt: l10n.setting,
//                     onPressedR: () {
//                       AppSettings.openAppSettings(
//                           type: AppSettingsType.settings);
//                     },
//                   );
//                   return;
//                 }
//
//                 final file = await imgPicker.getImage(ImageSource.gallery);
//                 if (file != null) {
//                   onPicked(file);
//                 }
//                 pop();
//               },
//               child: Text(l10n.lib),
//             ),
//           ],
//           cancelButton: CupertinoActionSheetAction(
//             onPressed: pop,
//             child: Text(l10n.cancel),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> showPickImageDialog({
//     required Function(File file) onPicked,
//     String? titleInput,
//     BuildContext? context,
//   }) async {
//     final l10n = AppLocalizations.of(context ?? AppRouter.context!)!;
//     final title = titleInput ?? l10n.pickImgFrom;
//     showCupertinoDialog<void>(
//       context: context ?? AppRouter.context!,
//       useRootNavigator: false,
//       barrierDismissible: true,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         // message: title.isEmpty ? null : Text(title, style: k2d500.grey600),
//         title: Text(title, style: k2d500),
//         actions: <CupertinoDialogAction>[
//           CupertinoDialogAction(
//             onPressed: () async {
//               final access =
//               await imgPicker.permissionCamera(ImageSource.camera);
//               if (!access) {
//                 showAlertDialog(
//                   title: l10n.noti,
//                   content: l10n.plsGrantPermission,
//                   rTxt: l10n.setting,
//                   onPressedR: () {
//                     AppSettings.openAppSettings(type: AppSettingsType.settings);
//                   },
//                 );
//                 return;
//               }
//
//               final file = await imgPicker.getImage(ImageSource.camera);
//               if (file != null) {
//                 onPicked(file);
//               }
//               pop();
//             },
//             child: Text(
//               'Camera',
//               style: k2d400.primaryFFts,
//             ),
//           ),
//           CupertinoDialogAction(
//             onPressed: () async {
//               final access =
//               await imgPicker.permissionCamera(ImageSource.gallery);
//               if (!access) {
//                 showAlertDialog(
//                   title: l10n.noti,
//                   content: l10n.plsGrantPermission,
//                   rTxt: l10n.setting,
//                   onPressedR: () {
//                     AppSettings.openAppSettings(type: AppSettingsType.settings);
//                   },
//                 );
//                 return;
//               }
//               final file = await imgPicker.getImage(ImageSource.gallery);
//               if (file != null) {
//                 onPicked(file);
//               }
//               pop();
//             },
//             child: Text(
//               l10n.lib,
//               style: k2d400.primaryFFts,
//             ),
//           ),
//           // CupertinoDialogAction(
//           //   onPressed: pop,
//           //   child: Text('Huỷ', style: k2d400.redText),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Future showSingleAlertDialog({
//     required String title,
//     required String content,
//     BuildContext? context,
//     Function()? onPressed,
//   }) {
//     return showCupertinoDialog<void>(
//       // useRootNavigator: true,
//       context: context ?? AppRouter.context!,
//       // barrierColor: Colors.black.withOpacity(0.2),
//       builder: (BuildContext context) => Theme(
//         data: ThemeData.light(),
//         child: CupertinoAlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: <CupertinoDialogAction>[
//             CupertinoDialogAction(
//               isDestructiveAction: true,
//               onPressed: onPressed ?? pop,
//               child: Text(
//                 AppLocalizations.of(context)!.close,
//                 style: k2d500.primaryFFts,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future showAlertDialog({
//     required String title,
//     required String content,
//     required String rTxt,
//     String? leftTxt,
//     TextStyle? lStyle,
//     TextStyle? rStyle,
//     void Function() onPressedR = pop,
//     void Function() onPressedL = pop,
//     BuildContext? context,
//     bool barrierDismissible = true,
//   }) {
//     return showCupertinoDialog<void>(
//       // useRootNavigator: true,
//       barrierDismissible: barrierDismissible,
//       context: context ?? AppRouter.context!,
//       // barrierColor: Colors.black.withOpacity(0.2),
//       builder: (BuildContext _) => Theme(
//         data: ThemeData.light(),
//         child: CupertinoAlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: <CupertinoDialogAction>[
//             leftTxt == null
//                 ? CupertinoDialogAction(
//               isDestructiveAction: true,
//               onPressed: pop,
//               child: Text(
//                 AppLocalizations.of(context ?? AppRouter.context!)!
//                     .cancel,
//               ),
//             )
//                 : CupertinoDialogAction(
//               isDestructiveAction: false,
//               onPressed: onPressedL,
//               child: Text(leftTxt, style: lStyle ?? k2d500.primaryFFts),
//             ),
//             CupertinoDialogAction(
//               isDestructiveAction: false,
//               onPressed: onPressedR,
//               child: Text(rTxt, style: rStyle ?? k2d500.primaryFFts),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> showFullscreenLoadingDialog(BuildContext context) async {
//     await showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       pageBuilder: (BuildContext context, a, s) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: const LoadingFullScreen(),
//         );
//       },
//     );
//   }
//
// }
//
// final showManager = ShowManager.instance;
