import 'package:Foodtour/ui/detail/providers/notifier.dart';
import 'package:Foodtour/ui/detail/widget/appbar_detail.dart';
import 'package:Foodtour/ui/detail/widget/info_card.dart';
import 'package:Foodtour/ui/detail/widget/ratingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class DetailScreen extends ConsumerWidget {
  final Map<String, dynamic> selectedItem;

  const DetailScreen({super.key, required this.selectedItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      ref.read(detailNotifierProvider.notifier).setSelectedItem(selectedItem);
    });

    final item = ref.watch(detailNotifierProvider).selectedItem;
    final isLoading = ref.watch(detailNotifierProvider).isLoading;

    return WillPopScope(
      onWillPop: () async {
        final shouldRate = await showDialog<bool>(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Đánh giá địa điểm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(16),
                        const Text(
                          'Bạn có muốn đánh giá địa điểm này không?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                backgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Không', style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                backgroundColor: Colors.green.shade400,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Có', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.star_rate_rounded, size: 48, color: Colors.amber.shade600),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        if (shouldRate == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RatingScreen(place: item),
          ));
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: DetailAppBar(item: item),
        backgroundColor: Colors.red.shade300,
        body: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
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
      ),
    );
  }
}
