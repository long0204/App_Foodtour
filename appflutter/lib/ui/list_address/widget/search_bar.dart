import 'package:flutter/material.dart';
import '../../../data/model/restaurant.dart';

class RestaurantSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RestaurantSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Tìm tên quán...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class RestaurantTypeDropdown extends StatelessWidget {
  final String? selectedType;
  final List<Restaurant> restaurants;
  final ValueChanged<String?> onChanged;

  const RestaurantTypeDropdown({
    super.key,
    required this.selectedType,
    required this.restaurants,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = restaurants.map((e) => e.type).toSet().toList()..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        hint: const Text('Lọc theo loại quán'),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('Tất cả'),
          ),
          ...types
              .map((type) => DropdownMenuItem<String>(
            value: type,
            child: Text(type!),
          ))
              .toList(),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.filter_list),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
