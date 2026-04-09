import 'package:Foodtour/utils/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../services/location_service.dart';
import '../../../providers/community_provider.dart';

part 'notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  FutureOr<Position?> build() async {
    return _fetchUserLocation();
  }

  Future<Position?> _fetchUserLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        ref.read(suggestionProvider.notifier).fetchSuggestions(
              position.latitude,
              position.longitude,
            );
      }
      return position;
    } catch (e) {
      logger.e("Lỗi GPS Home: $e");
      return null;
    }
  }
}
