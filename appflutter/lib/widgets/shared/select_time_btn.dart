// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ting_x/config/gen/assets.gen.dart';
// import 'package:ting_x/widgets/base/btn.dart';
//
// import '../../config/themes/theme.dart';
//
// class SelectTimeBtn extends StatelessWidget {
//   const SelectTimeBtn(
//       {this.value = 'Thời gian',
//       required this.onTap,
//       this.hasValue = false,
//       super.key});
//   final String value;
//   final Function() onTap;
//   final bool hasValue;
//   @override
//   Widget build(BuildContext context) {
//     return ZoomTap(
//       onTap: onTap,
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               border: Border.all(color: hasValue ? primaryFF : grey300),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
//             child: Row(
//               children: [
//                 Assets.icons.calendarDate.svg(),
//                 Text(value, style: k2d400),
//                 SizedBox(height: 16.w, child: Assets.icons.chevronDown.svg())
//               ],
//             ),
//           ),
//           if (hasValue)
//             Positioned(
//                 right: 1,
//                 top: 1,
//                 child: CircleAvatar(
//                   radius: 5.w,
//                   backgroundColor: red500,
//                 ))
//         ],
//       ),
//     );
//   }
// }
