import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifier.dart';

class ConfettiDisplay extends ConsumerWidget {
  const ConfettiDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(spinWheelNotifierProvider.notifier).confettiController;

    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      emissionFrequency: 0.5,
      numberOfParticles: 20,
      minBlastForce: 10,
      maxBlastForce: 100,
    );
  }
}
