import 'dart:io';

import 'package:Foodtour/ui/home/providers/notifier.dart';  // Nhập provider
import 'package:Foodtour/ui/home/widget/action_button.dart';
import 'package:Foodtour/ui/home/widget/item_detail_card.dart';
import 'package:Foodtour/ui/home/widget/item_dropdown.dart';
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
                Container(
                  height: screenHeight * 0.3,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Kiểm tra và hiển thị ảnh avatar bên trái
                      FutureBuilder<String?>(
                        future: getAvatarPath(true),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return Positioned(
                              left: 0,
                              top: 50,
                              child: Image.file(
                                File(snapshot.data!),
                                width: 100,
                                height: 100,
                              ),
                            );
                          } else {
                            return Positioned(
                              left: 0,
                              top: 50,
                              child: Image.asset(
                                'asset/avtllac.gif',
                                width: 100,
                                height: 100,
                              ),
                            );
                          }
                        },
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
                        child: FutureBuilder<DateTime?>(
                          future: getStartDate(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // loading
                            } else if (snapshot.hasData && snapshot.data != null) {
                              final days = calculateDaysFromDate(snapshot.data!);
                              return Text(
                                '$days',
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
                              );
                            } else {
                              return const Text(
                                'Chưa chọn ngày',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              );
                            }
                          },
                        ),
                      ),
                      // Kiểm tra và hiển thị ảnh avatar bên phải
                      FutureBuilder<String?>(
                        future: getAvatarPath(false),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return Positioned(
                              right: 0,
                              top: 50,
                              child: Image.file(
                                File(snapshot.data!),
                                width: 100,
                                height: 100,
                              ),
                            );
                          } else {
                            return Positioned(
                              right: 0,
                              top: 50,
                              child: Image.asset(
                                'asset/avthla.gif',
                                width: 100,
                                height: 100,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
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

