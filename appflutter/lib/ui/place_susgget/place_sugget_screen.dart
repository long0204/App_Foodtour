import 'package:flutter/material.dart';
import 'dart:convert';
import '../../data/model/restaurant.dart';

class PlaceSuggestionScreen extends StatefulWidget {
  const PlaceSuggestionScreen({super.key});

  @override
  State<PlaceSuggestionScreen> createState() => _PlaceSuggestionScreenState();
}

class _PlaceSuggestionScreenState extends State<PlaceSuggestionScreen> {
  List<Restaurant> _places = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gợi ý địa điểm')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          return ListTile(
            title: Text(place.name??''),
            subtitle: Text('${place.address}\n${place.price ?? ''}'),
            isThreeLine: true,
            leading: const Icon(Icons.place),
          );
        },
      ),
    );
  }
}
