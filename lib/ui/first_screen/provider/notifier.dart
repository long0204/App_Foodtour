// onboarding_notifier.dart
import 'dart:io';
import 'package:Foodtour/ui/first_screen/provider/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/route.dart';
import '../../../services/auth_service.dart';

class OnboardingNotifier extends Notifier<OnboardingState> {
  final picker = ImagePicker();

  @override
  OnboardingState build() => const OnboardingState();

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  Future<void> pickImage(bool isLeft) async {
    if (state.isPicking) return;
    state = state.copyWith(isPicking: true);
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        state = isLeft
            ? state.copyWith(avatarLeft: file)
            : state.copyWith(avatarRight: file);
      }
    } finally {
      state = state.copyWith(isPicking: false);
    }
  }

  Future<void> saveDataAndNavigate() async {
    if (state.selectedDate == null) return;

    final prefs = await SharedPreferences.getInstance();
    final username = authService.getUsername();
    if (username == null) {
      throw Exception("Không tìm thấy username trong SharedPreferences");
    }

    String? avatarLeftUrl;
    String? avatarRightUrl;
    final storageRef = FirebaseStorage.instance.ref();

    if (state.avatarLeft != null) {
      final leftRef = storageRef.child('avatars/${username}_left.jpg');
      await leftRef.putFile(state.avatarLeft!);
      avatarLeftUrl = await leftRef.getDownloadURL();
    }

    if (state.avatarRight != null) {
      final rightRef = storageRef.child('avatars/${username}_right.jpg');
      await rightRef.putFile(state.avatarRight!);
      avatarRightUrl = await rightRef.getDownloadURL();
    }

    // Lưu dữ liệu local
    await prefs.setString('start_date', state.selectedDate!.toIso8601String());
    if (state.avatarLeft != null) {
      await prefs.setString('avatar_left', state.avatarLeft!.path);
    }
    if (state.avatarRight != null) {
      await prefs.setString('avatar_right', state.avatarRight!.path);
    }

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(username);

    await userDocRef.set({
      'username': username,
      'start_date': state.selectedDate!.toIso8601String(),
      if (avatarLeftUrl != null) 'avatar_left_url': avatarLeftUrl,
      if (avatarRightUrl != null) 'avatar_right_url': avatarRightUrl,
    }, SetOptions(merge: true));

    push(rootRoute);
  }

}

final onboardingNotifierProvider =
NotifierProvider<OnboardingNotifier, OnboardingState>(() => OnboardingNotifier());
