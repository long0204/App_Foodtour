import 'package:Foodtour/ui/detail/providers/notifier.dart';
import 'package:Foodtour/ui/detail/widget/appbar_detail.dart';
import 'package:Foodtour/ui/detail/widget/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/base/btn.dart';

class DetailScreen extends ConsumerWidget {
  final Map<String, dynamic> selectedItem;

  const DetailScreen({super.key, required this.selectedItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      ref.read(detailNotifierProvider.notifier).setSelectedItem(selectedItem);
    });

    final item = ref.watch(detailNotifierProvider).selectedItem;

    return Scaffold(
      appBar: DetailAppBar(item: item),
      backgroundColor: Colors.red.shade300,
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset('asset/nhieutim.json', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InfoCard(item: item),
                const SizedBox(height: 16),
                Lottie.asset('asset/Food.json', width: 200, height: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
