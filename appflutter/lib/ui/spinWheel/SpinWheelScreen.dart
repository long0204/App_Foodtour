import 'package:Foodtour/ui/spinWheel/providers/notifier.dart';
import 'package:Foodtour/ui/spinWheel/widget/confetti_display.dart';
import 'package:Foodtour/ui/spinWheel/widget/spin_button.dart';
import 'package:Foodtour/ui/spinWheel/widget/spin_result.dart';
import 'package:Foodtour/ui/spinWheel/widget/spin_wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpinWheelScreen extends ConsumerWidget {
  const SpinWheelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spinWheelNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vòng quay lú lẫn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinWheel(),
            if (state.showResult)
              const Positioned(
                bottom: 16,
                child: ResultContainer(),
              ),
            const SpinButton(),
            const ConfettiDisplay(),
          ],
        ),
      ),
    );
  }
}
