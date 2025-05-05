// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import '../../utils/util.dart';
//
// class BottomSpace extends StatelessWidget {
//   const BottomSpace({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: mqPadding.bottom + 20);
//   }
// }
//
// class LoadingBottom extends StatelessWidget {
//   const LoadingBottom(this.isEnd, {super.key});
//   final bool isEnd;
//   @override
//   Widget build(BuildContext context) {
//     return isEnd
//         ? SizedBox(
//             height: mqPadding.bottom + 40,
//             child: Center(
//               child: Text(
//                 AppLocalizations.of(context)!.hasEndList,
//                 style: k2d400.grey600ts.copyWith(fontSize: 14),
//               ),
//             ),
//           )
//         : SizedBox(
//             height: mqPadding.bottom + 20,
//             child: Center(
//               child: LoadingAnimationWidget.waveDots(
//                 color: primaryFF,
//                 size: 40,
//               ),
//             ),
//           );
//   }
// }
