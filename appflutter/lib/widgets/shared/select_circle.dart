import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/theme.dart';

class SelectCircle extends StatelessWidget {
  const SelectCircle(this.selected, {super.key});
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return selected
        ? CircleAvatar(
            backgroundColor: primaryB5,
            radius: 8.w,
            child: CircleAvatar(
              radius: 3.w,
              backgroundColor: white,
            ),
          )
        : Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: grey600,
                width: 1.w,
              ),
            ),
          );
  }
}
