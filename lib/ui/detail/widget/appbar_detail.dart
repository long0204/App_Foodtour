import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/base/btn.dart';
import '../providers/notifier.dart';

class DetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Map<String, dynamic> item;

  const DetailAppBar({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Thông tin quán', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red.shade300,
      actions: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ZoomTap(
            child: const Icon(Icons.favorite, color: Colors.red),
            onTap: () async {
              await ref.read(detailNotifierProvider.notifier).addFavoritePlace(ref, item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[400],
                  content: const Text(
                    'Đã thêm vào danh sách yêu thích',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
