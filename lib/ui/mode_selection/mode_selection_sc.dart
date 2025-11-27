import 'package:Foodtour/ui/mode_selection/provider/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants/enum.dart';
import '../../core/route.dart';

class ModeSelectScreen extends ConsumerWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn chế độ sử dụng")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildModeButton(
              context,
              ref,
              title: "Đi cùng nhóm bạn",
              icon: Icons.group,
              mode: ModeType.group,
              routePath: groupRoute,
            ),
            const SizedBox(height: 24),
            _buildModeButton(
              context,
              ref,
              title: "Đi cùng người yêu",
              icon: Icons.favorite,
              mode: ModeType.couple,
              routePath: homeRoute,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
      BuildContext context,
      WidgetRef ref, {
        required String title,
        required IconData icon,
        required ModeType mode,
        required String routePath,
      }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 32),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        ref.read(modeNotifierProvider.notifier).selectMode(mode);
        context.go(routePath);
      },
    );
  }
}
