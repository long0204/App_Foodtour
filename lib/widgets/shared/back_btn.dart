import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/color.dart';
import '../../config/themes/style.dart';
import '../../core/route.dart';
import '../base/btn.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomTap(
        onTap: pop,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 20.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration:  BoxDecoration(
              color: white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              boxShadow: [cirContainerShadow],
            ),
            child: Icon(Icons.arrow_back, color: Colors.black )
          ),
        ));
  }
}
