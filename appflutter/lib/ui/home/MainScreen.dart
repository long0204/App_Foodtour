import 'package:Foodtour/ui/home/providers/notifier.dart';  // Nhập provider
import 'package:Foodtour/ui/home/widget/action_button.dart';
import 'package:Foodtour/ui/home/widget/item_detail_card.dart';
import 'package:Foodtour/ui/home/widget/item_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';

class RandomItemScreen extends ConsumerWidget {
  const RandomItemScreen({super.key});

  int calculateDaysFromDate(DateTime targetDate) {
    final currentDate = DateTime.now().add(const Duration(days: 1));
    final difference = currentDate.difference(targetDate).inDays;
    return difference.abs();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(randomItemNotifierProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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
                Container(
                  height: screenHeight * 0.3,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 50,
                        child: Image.asset(
                          'asset/avtllac.gif',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Center(
                        child: Lottie.asset(
                          'asset/heart2.json',
                          width: 150,
                          height: 150,
                          repeat: true,
                          reverse: true,
                          animate: true,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${calculateDaysFromDate(DateTime(2023, 6, 4))}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black54,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 50,
                        child: Image.asset(
                          'asset/avthla.gif',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                const ItemDropdown(),
                const Gap(20),
                const ActionButtons(),
                const Gap(20),
                const ItemDetailCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
