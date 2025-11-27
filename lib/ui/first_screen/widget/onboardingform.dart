import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../provider/notifier.dart';
import '../provider/state.dart';

class OnboardingForm extends StatelessWidget {
  final OnboardingState state;
  final OnboardingNotifier notifier;

  const OnboardingForm({
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime(now.year - 10),
              lastDate: now,
            );
            if (picked != null) notifier.selectDate(picked);
          },
          child: const Text("Chọn ngày bắt đầu"),
        ),
        const Gap(8),
        if (state.selectedDate != null)
          Text(
            "Ngày đã chọn: ${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}",
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => notifier.pickImage(true),
              child: state.avatarLeft != null
                  ? Image.file(state.avatarLeft!, width: 80, height: 80)
                  : const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
            GestureDetector(
              onTap: () => notifier.pickImage(false),
              child: state.avatarRight != null
                  ? Image.file(state.avatarRight!, width: 80, height: 80)
                  : const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
