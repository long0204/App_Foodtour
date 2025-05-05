import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../popup/HeartShape.dart';
import '../providers/notifier.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => HeartShapeDialog(
        title: 'Chọn loại quán đi',
        content: 'Không biết đi đâu thì đi về nhá !',
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(randomItemNotifierProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            if (ref.read(randomItemNotifierProvider).selectedLoai ==
                "Chọn loại quán") {
              _showPopup(context);
              return;
            }
            notifier.getRandomItem();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: Size(10, 40),
          ),
          child: Row(
            children: [
              Image.asset('asset/dice.png', width: 20, height: 20),
              SizedBox(width: 5),
              Text('Quán ngẫu nhiên',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: () => _showPopup(context),
          icon: Icon(Icons.heart_broken, color: Colors.white),
          label: Text('Em không biết',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent[400],
            minimumSize: Size(150, 40),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }
}
