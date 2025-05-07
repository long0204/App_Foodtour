import 'package:Foodtour/ui/home/providers/notifier.dart';
import 'package:Foodtour/ui/home/widget/action_button.dart';
import 'package:Foodtour/ui/home/widget/appbar_love.dart';
import 'package:Foodtour/ui/home/widget/item_detail_card.dart';
import 'package:Foodtour/ui/home/widget/item_dropdown.dart';
import 'package:Foodtour/ui/home/widget/love_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomItemScreen extends ConsumerWidget {
  const RandomItemScreen({super.key});

  Future<DateTime?> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('start_date');
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  int calculateDaysFromDate(DateTime targetDate) {
    final now = DateTime.now();
    return now.difference(targetDate).inDays + 1;
  }

  Future<String?> getAvatarPath(bool isLeft) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isLeft ? 'avatar_left' : 'avatar_right');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(randomItemNotifierProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const LoveAppBar(),
      backgroundColor: Colors.red.shade300,
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'asset/nhieutim.json',
              fit: BoxFit.cover,
              repeat: true,
              reverse: false,
              animate: true,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Gap(screenHeight * 0.05),
                LoveHeader(height: screenHeight * 0.3),
                const Gap(24),
                const ItemDropdown(),
                const Gap(20),
                const ActionButtons(),
                const Gap(20),
                if (state.selectedItem != null && state.selectedItem.isNotEmpty)
                  const ItemDetailCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}