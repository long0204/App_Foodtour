import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifier.dart';

class SpinWheel extends ConsumerWidget {
  const SpinWheel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(spinWheelNotifierProvider.notifier);
    final items = notifier.items;

    return FortuneWheel(
      selected: notifier.selectedController.stream,
      items: items
          .map((e) => FortuneItem(
        child: Text(e),
        style: FortuneItemStyle(color: Colors.primaries[items.indexOf(e) % Colors.primaries.length]),
      ))
          .toList(),
      onAnimationStart: notifier.onSpinStart,
      onAnimationEnd: () => notifier.onSpinEnd(context),
    );
  }
}
