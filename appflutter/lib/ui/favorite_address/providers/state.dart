import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/favorite_address_model.dart';
import 'notifier.dart';

final favoritePlacesProvider = StateNotifierProvider<FavoritePlacesNotifier, List<FavoritePlace>>(
      (ref) => FavoritePlacesNotifier(),
);
