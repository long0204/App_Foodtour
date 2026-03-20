import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/restaurant.dart';
import '../../providers/community_provider.dart';

class FoodMapScreen extends ConsumerWidget {
  const FoodMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(communityProvider);

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(10.762622, 106.660172),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.dinos.foodtour',
          ),
          MarkerLayer(
            markers: restaurantsAsync.maybeWhen(
              data: (list) => list.map((res) {
                return Marker(
                  point: LatLng(10.762622, 106.660172),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showRestaurantQuickView(context, res),
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                );
              }).toList(),
              orElse: () => [],
            ),
          ),
        ],
      ),
    );
  }

  void _showRestaurantQuickView(BuildContext context, Restaurant res) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 150,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(res.imageUrls?.first ?? '', width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(res.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(res.address ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text("⭐ ${res.rating}", style: const TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}