import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/model/restaurant.dart';

class SelectLocationDialog extends StatelessWidget {
  const SelectLocationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Restaurant>('restaurants');
    final items = box.values.toList();

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Chọn địa điểm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name??''),
                  subtitle: Text(item.address ?? ''),
                  onTap: () {
                    Navigator.of(context).pop(item.name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
