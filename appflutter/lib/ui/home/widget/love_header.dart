import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoveHeader extends StatelessWidget {
  final double height;

  const LoveHeader({super.key, required this.height});

  Future<DateTime?> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('start_date');
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  Future<String?> getAvatarPath(bool isLeft) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isLeft ? 'avatar_left' : 'avatar_right');
  }

  int calculateDaysFromDate(DateTime targetDate) {
    final now = DateTime.now();
    return now.difference(targetDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
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
    );
  }
}
