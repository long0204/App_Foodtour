import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tab_provider.dart';
import '../account/account_screen.dart';
import '../add_place/add_place_screen.dart';
import '../auth/login_screen.dart';
import '../auth/providers/auth_notifier.dart';
import '../home/home_screen.dart';
import '../list_address/restaurant_list_screen.dart';
import '../map/food_map_screen.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const FoodMapScreen(),
    const AddPlaceScreen(),
    const RestaurantListScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(tabIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Khám phá'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: 'Chia sẻ'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}