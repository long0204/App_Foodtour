import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detail/DetailScreen.dart';
import '../providers/notifier.dart';

class ItemDetailCard extends ConsumerWidget {
  const ItemDetailCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(randomItemNotifierProvider).selectedItem;

    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(selectedItem: selectedItem),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _infoRow("STT", "${selectedItem["STT"]}"),
              _infoRow("Loại", "${selectedItem["Loại"]}", color: Colors.green),
              _infoRow("Tên quán", "${selectedItem["Tên quán"]}",
                  color: Colors.orange),
              _infoRow("Địa chỉ", "${selectedItem["Địa chỉ"]}",
                  color: Colors.red),
              _infoRow("Giá", "${selectedItem["Giá"]}", color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
