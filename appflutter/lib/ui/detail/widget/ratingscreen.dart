import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Foodtour/ui/detail/providers/notifier.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> place;
  const RatingScreen({super.key, required this.place});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  double foodRating = 0;
  double drinkRating = 0;
  double ambianceRating = 0;
  final TextEditingController noteController = TextEditingController();

  List<File> selectedImages = [];

  Future<void> pickMultipleImages(BuildContext context) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.red),
              title: const Text('Chụp ảnh'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() => selectedImages.add(File(pickedFile.path)));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.red),
              title: const Text('Chọn từ thư viện'),
              onTap: () async {
                Navigator.pop(context);
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: true,
                );
                if (result != null) {
                  setState(() {
                    selectedImages
                        .addAll(result.paths.map((path) => File(path!)));
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(detailNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá địa điểm'),
        backgroundColor: Colors.red.shade400,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RatingCard(
                  title: 'Món ăn',
                  rating: foodRating,
                  onChanged: (val) => setState(() => foodRating = val),
                ),
                const Gap(8),
                RatingCard(
                  title: 'Đồ uống',
                  rating: drinkRating,
                  onChanged: (val) => setState(() => drinkRating = val),
                ),
                const Gap(8),
                RatingCard(
                  title: 'Không gian',
                  rating: ambianceRating,
                  onChanged: (val) => setState(() => ambianceRating = val),
                ),
                const Gap(16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Hình ảnh đánh giá',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const Gap(8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => pickMultipleImages(context),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Chọn hoặc chụp ảnh'),
                ),
                const Gap(8),
                if (selectedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedImages.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8),
                    itemBuilder: (_, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const Gap(16),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green.shade400,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                      ref
                          .read(detailNotifierProvider.notifier)
                          .submitRating(
                        food: foodRating,
                        drink: drinkRating,
                        ambiance: ambianceRating,
                        note: noteController.text,
                        images: selectedImages,
                        place: widget.place,
                        context: context,
                      );
                    },
                    child: const Text('Gửi đánh giá'),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final String title;
  final double rating;
  final ValueChanged<double> onChanged;

  const RatingCard({
    super.key,
    required this.title,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            Slider(
              value: rating,
              onChanged: onChanged,
              min: 0,
              max: 5,
              divisions: 5,
              label: rating.toString(),
              activeColor: Colors.red.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
