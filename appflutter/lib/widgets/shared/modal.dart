// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
//
// import '../../config/themes/theme.dart';
// import '../../utils/util.dart';
//
// class MyModal extends StatelessWidget {
//   const MyModal({
//     required this.listView,
//     this.title = '',
//     this.top = const [],
//     this.bot = const [],
//     this.initialChildSize = 0.88,
//     this.expand = true,
//     super.key,
//     this.onTapOutside,
//   });
//
//   final double initialChildSize;
//   final Function()? onTapOutside;
//
//   /// Phía trên listView
//   final List<Widget> top;
//   final Widget Function(ScrollController scrollController) listView;
//
//   /// Phía dưới listView
//   final List<Widget> bot;
//   final bool expand;
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//         maxChildSize: 0.93,
//         initialChildSize: initialChildSize,
//         minChildSize: initialChildSize - 0.02,
//         expand: expand,
//         snap: true,
//         builder: (_, c) {
//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//               if (onTapOutside != null) onTapOutside!();
//             },
//             child: Container(
//               width: double.maxFinite,
//               height: mqSize.height - 64.w,
//               padding: EdgeInsets.only(top: 8.w, left: 24.w, right: 24.w),
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(32),
//                       topRight: Radius.circular(32))),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: 60.w,
//                     height: 4.w,
//                     margin: EdgeInsets.only(top: 4.w),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4), color: grey400),
//                   ),
//                   Gap(8.w),
//                   Text(title, style: k2d600),
//                   // Gap(24.w),
//                   ...top,
//                   Expanded(child: listView(c)),
//                   ...bot
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
