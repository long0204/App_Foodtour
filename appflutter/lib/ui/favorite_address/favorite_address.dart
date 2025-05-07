import 'package:Foodtour/ui/favorite_address/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlacesScreen extends ConsumerWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlaces = ref.watch(favoritePlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Quán Yêu Thích'),
        backgroundColor: Colors.red.shade300,
      ),
      body: favoritePlaces.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/images/shared/empty.png', height: 120, width: 160),
            Text(
              'Không có danh sách quán yêu thích',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Colors.grey.shade500,
                fontSize: 14,
                letterSpacing: -0.05,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          final place = favoritePlaces[index];
          return ListTile(
            title: Text(place.name),
            subtitle: Text(place.address),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref.read(favoritePlacesProvider.notifier).removeFavoritePlace(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa khỏi yêu thích')),
                );
              },
            ),
            onTap: () => ref.read(favoritePlacesProvider.notifier).askForDirections(context, place.address),
          );
        },
      ),
    );
  }
}
