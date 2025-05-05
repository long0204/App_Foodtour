import 'dart:io';

import 'package:Foodtour/ui/home/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  DateTime? selectedDate;
  File? avatarLeft;
  File? avatarRight;
  final picker = ImagePicker();
  bool isPicking = false;

  Future<void> _pickImage(bool isLeft) async {
    if (isPicking) return;
    isPicking = true;
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          if (isLeft) avatarLeft = File(picked.path);
          else avatarRight = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    } finally {
      isPicking = false;
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _saveData() async {
    if (selectedDate == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('start_date', selectedDate!.toIso8601String());
    if (avatarLeft != null) {
      await prefs.setString('avatar_left', avatarLeft!.path);
    }
    if (avatarRight != null) {
      await prefs.setString('avatar_right', avatarRight!.path);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RandomItemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
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
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: _selectDate,
                          child: const Text("Chọn ngày bắt đầu"),
                        ),
                        const Gap(8),
                        if (selectedDate != null)
                          Text(
                            "Ngày đã chọn: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        const Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () => _pickImage(true),
                              child: avatarLeft != null
                                  ? Image.file(avatarLeft!, width: 80, height: 80)
                                  : const Icon(Icons.person, size: 80, color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () => _pickImage(false),
                              child: avatarRight != null
                                  ? Image.file(avatarRight!, width: 80, height: 80)
                                  : const Icon(Icons.person, size: 80, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Lưu & tiếp tục",
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
