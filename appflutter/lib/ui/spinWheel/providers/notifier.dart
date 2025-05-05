import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';

import '../../../widgets/shared/dialog_custom.dart';

part 'state.dart';

final spinWheelNotifierProvider = NotifierProvider<SpinWheelNotifier, SpinWheelState>(
  SpinWheelNotifier.new,
);

class SpinWheelNotifier extends Notifier<SpinWheelState> {
  late StreamController<int> selectedController;
  late ConfettiController confettiController;

  final items = [
    'Nướng', 'Bún', 'Gà', 'Vịt', 'Lẩu', 'Coffee', 'Bánh', 'Đồ hàn, gà rán', 'Chè', 'Nem',
  ];

  @override
  SpinWheelState build() {
    selectedController = StreamController<int>.broadcast();
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
    return SpinWheelState(
      isSpinning: false,
      showResult: false,
      selectedIndex: 0,
    );
  }

  void spin() {
    if (state.isSpinning) return;

    final index = Random().nextInt(items.length);
    state = state.copyWith(isSpinning: true, showResult: false);
    selectedController.add(index);
    state = state.copyWith(selectedIndex: index);
  }

  void onSpinStart() {
    state = state.copyWith(isSpinning: true, showResult: false);
  }

  Future<void> onSpinEnd(BuildContext context) async {
    final result = items[state.selectedIndex];
    confettiController.play();
    state = state.copyWith(isSpinning: false, showResult: true);
    await showCustomSuccessDialog(context, result);
    //_showPopup(context, result);
  }

  void _showPopup(BuildContext context, String result) {


    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     backgroundColor: Colors.green,
    //     content: Text(result, style: const TextStyle(fontSize: 30, color: Colors.yellow)),
    //     actions: [
    //       ElevatedButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: const Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void onDispose() {
    selectedController.close();
    confettiController.dispose();
  }
}
