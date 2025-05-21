import 'dart:io';
import 'package:Foodtour/ui/account/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../services/auth_service.dart';

final avatarNotifierProvider =
NotifierProvider<AvatarNotifier, AvatarState>(AvatarNotifier.new);

class AvatarNotifier extends Notifier<AvatarState> {
  @override
  AvatarState build() {
    loadAvatar();
    return const AvatarState();
  }

  Future<void> loadAvatar() async {
    final key = authService.getToken();
    if (key == null) return;

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('key', isEqualTo: key)
        .get();

    if (query.docs.isNotEmpty) {
      final avatarUrl = query.docs.first.data()['avatar'] as String?;
      if (avatarUrl != null) {
        state = state.copyWith(avatarUrl: avatarUrl);
      }
    }
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      state = state.copyWith(isLoading: true);
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        File file = File(pickedFile.path);

        final key = authService.getToken();
        if (key == null) throw Exception("Chưa đăng nhập");

        final ref = FirebaseStorage.instance.ref().child('avatars/$key.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        await authService.updateProfile(key: key, avatar: url);
        state = state.copyWith(avatarUrl: url);
      }
    } catch (e) {

    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
