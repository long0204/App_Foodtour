import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../spinWheel/SpinWheelScreen.dart';
import '../providers/notifier.dart';

class ItemDropdown extends ConsumerWidget {
  const ItemDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(randomItemNotifierProvider);
    final notifier = ref.read(randomItemNotifierProvider.notifier);
    final loaiList = notifier.getLoaiList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: state.selectedLoai,
            onChanged: (String? newValue) {
              if (newValue != null) {
                notifier.selectLoai(newValue);
              }
            },
            items: loaiList.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpinWheelScreen(),
                ),
              );
              if (result != null && result is String) {
                notifier.selectLoai(result);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(10, 40),
            ),
            child: Row(
              children: [
                Image.asset('asset/spinwheel.png', width: 20, height: 20),
                SizedBox(width: 5),
                Text('Quay loại quán', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
