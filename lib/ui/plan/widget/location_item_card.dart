import 'package:Foodtour/ui/plan/widget/select_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../providers/create_plan_notifier.dart';

class LocationItemCard extends StatelessWidget {
  final LocationItem locationItem;
  final int index;
  final VoidCallback removeLocation;

  const LocationItemCard({
    required this.locationItem,
    required this.index,
    required this.removeLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: locationItem.placeController,
              decoration: InputDecoration(
                labelText: 'Địa điểm',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final selected = await showDialog<String>(
                      context: context,
                      builder: (_) => const SelectLocationDialog(),
                    );
                    if (selected != null) {
                      locationItem.placeController.text = selected;
                    }
                  },
                ),
              ),
            ),

            const Gap(8),
            TextFormField(
              controller: locationItem.durationController,
              decoration: const InputDecoration(
                labelText: 'Thời gian ở địa điểm',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const Gap(8),
            TextFormField(
              controller: locationItem.costController,
              decoration: const InputDecoration(
                labelText: 'Kinh phí dự kiến',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: removeLocation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
