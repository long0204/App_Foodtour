import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../account/account_screen.dart';
import '../add_place/add_place_screen.dart';
import '../home/home_screen.dart';
import '../map/food_map_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
     const FoodMapScreen(),
     const AddPlaceScreen(),
    //const RestaurantListScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Khám phá'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: 'Chia sẻ'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
        ],
      ),
    );
  }
}