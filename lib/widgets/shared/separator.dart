// import 'package:flutter/material.dart';
// import 'package:ting_x/config/themes/theme.dart';
//
// class MySeparator extends StatelessWidget {
//   const MySeparator({super.key, this.height = 1, this.color = D6D8FF});
//   final double height;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final boxWidth = constraints.constrainWidth();
//         const double dashWidth = 6;
//         final dashHeight = height;
//         final dashCount = (boxWidth / (2 * dashWidth)).floor();
//         return Flex(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           direction: Axis.horizontal,
//           children: List.generate(dashCount, (_) {
//             return SizedBox(
//               width: dashWidth,
//               height: dashHeight,
//               child: DecoratedBox(decoration: BoxDecoration(color: color)),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
//
// class DottedLineVertical extends StatelessWidget {
//   final double height;
//   const DottedLineVertical({super.key, required this.height});
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(2, height), // Chiều rộng và cao của đường
//       painter: DottedLinePainter(),
//     );
//   }
// }
//
// class DottedLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = primaryFF
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     double dashHeight = 4;
//     double dashSpace = 3;
//     double startY = 0;
//
//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width / 2, startY),
//         Offset(size.width / 2, startY + dashHeight),
//         paint,
//       );
//       startY += dashHeight + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
