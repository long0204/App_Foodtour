import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifier.dart';

class SpinButton extends ConsumerWidget {
  const SpinButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(spinWheelNotifierProvider.notifier);
    final isSpinning = ref.watch(spinWheelNotifierProvider.select((s) => s.isSpinning));

    return GestureDetector(
      onTap: () {
        if (!isSpinning)
          notifier.spin();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellowAccent[100]),
        child: const Center(
          child: Text('Spin', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
