// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:ting_x/widgets/base/base.dart';
//
// import '../../config/gen/assets.gen.dart';
// import '../../config/themes/theme.dart';
//
// class CustomTableCalendar extends StatefulWidget {
//   const CustomTableCalendar({
//     required this.onDaySelected,
//     this.focusedDay,
//     this.selectedDay,
//     this.firstDay,
//     super.key,
//   });
//   final DateTime? focusedDay;
//   final DateTime? selectedDay;
//   final DateTime? firstDay;
//
//   final void Function(DateTime selectedDay) onDaySelected;
//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomTableCalendarState createState() => _CustomTableCalendarState();
// }
//
// class _CustomTableCalendarState extends State<CustomTableCalendar> {
//   late DateTime _focusedDay;
//   DateTime? _selectedDay;
//
//   @override
//   void initState() {
//     _focusedDay = widget.focusedDay ?? DateTime.now().toLocal();
//     _selectedDay = widget.selectedDay;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: grey100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: EdgeInsets.all(12.w),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Tháng ${_focusedDay.month.toString().padLeft(2, '0')} - ${_focusedDay.year}',
//                 style: k2d600,
//               ),
//               Row(
//                 children: [
//                   ZoomTap(
//                     onTap: () {
//                       setState(() {
//                         _focusedDay = DateTime(
//                           _focusedDay.year,
//                           _focusedDay.month - 1,
//                         );
//                       });
//                     },
//                     child: Container(
//                       height: 32.w,
//                       width: 32.w,
//                       padding: EdgeInsets.all(5.w),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [cirContainerShadow],
//                       ),
//                       child: Assets.icons.chevronLeft.svg(),
//                     ),
//                   ),
//                   ZoomTap(
//                     onTap: () {
//                       setState(() {
//                         _focusedDay = DateTime(
//                           _focusedDay.year,
//                           _focusedDay.month + 1,
//                         );
//                       });
//                     },
//                     child: Container(
//                       height: 32.w,
//                       width: 32.w,
//                       margin: EdgeInsets.only(left: 14.w),
//                       padding: EdgeInsets.all(5.w),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [cirContainerShadow],
//                       ),
//                       child: Assets.icons.chevronRight.svg(),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           Gap(16.w),
//           SizedBox(
//             height: 192.w,
//             width: double.maxFinite,
//             child: TableCalendar(
//               shouldFillViewport: true,
//               headerVisible: false,
//               firstDay: widget.firstDay ?? DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.now().toLocal(),
//               focusedDay: _focusedDay,
//               onPageChanged: _onPageChanged,
//               selectedDayPredicate: _selectedDayPredicate,
//               onDaySelected: _onDaySelected,
//               headerStyle: _headerStyle,
//               calendarStyle: const CalendarStyle(),
//               daysOfWeekStyle: _daysOfWeekStyle,
//               locale: Intl.defaultLocale,
//               daysOfWeekHeight: 28.w,
//               calendarBuilders: CalendarBuilders(
//                 dowBuilder: _dowBuilder,
//                 defaultBuilder: _defaultBuilder,
//                 disabledBuilder: _disabledBuilder,
//                 selectedBuilder: _selectedBuilder,
//                 todayBuilder: _todayBuilder,
//                 outsideBuilder: _disabledBuilder,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onPageChanged(focusedDay) {
//     setState(() {
//       _focusedDay = focusedDay;
//     });
//   }
//
//   bool _selectedDayPredicate(DateTime date) {
//     return isSameDay(_selectedDay, date);
//   }
//
//   void _onDaySelected(selectedDay, focusedDay) {
//     widget.onDaySelected(selectedDay);
//     setState(() {
//       _selectedDay = selectedDay;
//       _focusedDay = focusedDay;
//     });
//   }
//
//   final HeaderStyle _headerStyle = const HeaderStyle(
//     formatButtonVisible: false,
//     titleCentered: true,
//     leftChevronVisible: false,
//     rightChevronVisible: false,
//   );
//   final DaysOfWeekStyle _daysOfWeekStyle =
//       DaysOfWeekStyle(weekendStyle: k2d600.s14, weekdayStyle: k2d600.s14);
//
//   Widget _dowBuilder(context, DateTime date) {
//     final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
//     BorderRadiusGeometry? radius;
//     if ((date.weekday % 7) == 0) {
//       radius = const BorderRadius.only(
//           topLeft: Radius.circular(4), bottomLeft: Radius.circular(4));
//     }
//     if ((date.weekday % 7) == 6) {
//       radius = const BorderRadius.only(
//           topRight: Radius.circular(4), bottomRight: Radius.circular(4));
//     }
//     return Container(
//       decoration: BoxDecoration(color: grey250, borderRadius: radius),
//       height: 30,
//       child: Center(
//         child: Text(
//           days[date.weekday % 7],
//           style: k2d600.s14,
//         ),
//       ),
//     );
//   }
//
//   Widget _defaultBuilder(context, DateTime date, focusedDay) {
//     return SizedBox(
//       height: 28.w,
//       child: Center(
//         child: Text(
//           date.day.toString(),
//           style: k2d400,
//         ),
//       ),
//     );
//   }
//
//   Widget _selectedBuilder(context, DateTime date, focusedDay) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4), color: primaryFF),
//       width: 40.w,
//       height: 28.w,
//       child: Center(
//         child: Text(
//           date.day.toString(),
//           style: k2d400.white,
//         ),
//       ),
//     );
//   }
//
//   Widget _todayBuilder(
//     BuildContext context,
//     DateTime date,
//     DateTime focusedDay,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: primaryFF)),
//       width: 40.w,
//       height: 28.w,
//       child: Center(
//         child: Text(
//           date.day.toString(),
//           style: k2d400,
//         ),
//       ),
//     );
//   }
//
//   Widget _disabledBuilder(
//     BuildContext context,
//     DateTime date,
//     DateTime focusedDay,
//   ) {
//     return SizedBox(
//       height: 28.w,
//       child: Center(
//         child: Text(
//           date.day.toString(),
//           style: k2d400.grey450ts,
//         ),
//       ),
//     );
//   }
// }
