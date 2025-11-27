import 'package:Foodtour/data/model/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantItemTile extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItemTile({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(restaurant.name ?? ''),
        subtitle: Text('${restaurant.type} • ${restaurant.address}'),
        trailing: IconButton(
          icon: const Icon(Icons.map, color: Colors.blue),
          onPressed: () {
            final encodedAddress = Uri.encodeComponent(restaurant.name ?? '');
            final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          },
        ),
      ),
    );
  }
}
