import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../providers/notifier.dart';

class NavigationPanel extends ConsumerWidget {
  const NavigationPanel({super.key});

  Widget _buildStepIcon(String? modifier) {
    IconData icon;
    if (modifier == null)
      return const Icon(Icons.straight, color: Colors.white, size: 35);
    if (modifier.contains('left'))
      icon = Icons.turn_left;
    else if (modifier.contains('right'))
      icon = Icons.turn_right;
    else
      icon = Icons.straight;

    return Icon(icon, color: Colors.white, size: 40.sp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(foodMapNotifierProvider);

    if (!state.isNavigating || state.navigationSteps.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentStep = state.navigationSteps[state.currentStepIndex];

    return Positioned(
      top: 50.h,
      left: 16.w,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1B5E20),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          children: [
            _buildStepIcon(currentStep['maneuver']['modifier']),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.distanceToNextStep > 1000
                        ? "${(state.distanceToNextStep / 1000).toStringAsFixed(1)} km"
                        : "${state.distanceToNextStep.toStringAsFixed(0)} m",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(state.currentInstruction,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () =>
                  ref.read(foodMapNotifierProvider.notifier).stopNavigation(),
            )
          ],
        ),
      ),
    );
  }
}
