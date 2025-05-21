import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../account/account_screen.dart';
import '../home/HomeScreen.dart';
import '../home/widget/appbar_love.dart';
import '../list_address/list_address_screen.dart';
import '../plan/plan_sc.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    const HomeScreen(),
    const PlansTab(),
    const RestaurantListScreen(),
    const AccountScreen(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  PreferredSizeWidget? _buildAppBar(int index) {
    switch (index) {
      case 0:
        return const LoveAppBar();
      default:
        return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(_selectedIndex),
      backgroundColor: Colors.red.shade300,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Kế Hoạch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Danh sách quán',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),

    );
  }
}
