import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import '../providers/notifier.dart';

class SpinWheel extends ConsumerWidget {
  const SpinWheel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(spinWheelNotifierProvider.notifier);
    final items = notifier.items;

    return StreamBuilder<int>(
      stream: notifier.selectedController.stream,  // Lắng nghe stream từ controller
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());  // Hiển thị loading nếu chưa có dữ liệu
        }

        final selectedIndex = snapshot.data!;  // Lấy selectedIndex từ stream

        return FortuneWheel(
          selected: Stream.value(selectedIndex),  // Dùng selectedIndex từ stream
          items: items
              .map((e) => FortuneItem(
            child: Text(e),
            style: FortuneItemStyle(color: Colors.primaries[items.indexOf(e) % Colors.primaries.length]),
          ))
              .toList(),
          onAnimationStart: notifier.onSpinStart,
          onAnimationEnd: () => notifier.onSpinEnd(context),
        );
      },
    );
  }
}
