// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  bool _isRequestingPermission = false;

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    if (_isRequestingPermission) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      _isRequestingPermission = true;
      permission = await Geolocator.requestPermission();
      _isRequestingPermission = false;

      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      return null;
    }
  }
}

final locationService = LocationService();