import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String _kImageAppbarHome = 'image_appbar_home';

  Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode
            ? const Duration(seconds: 10)
            : const Duration(hours: 1),
      ));

      await _remoteConfig.setDefaults(<String, dynamic>{
        _kImageAppbarHome: 'https://www.celebritycruises.com/blog/content/uploads/2022/04/best-food-in-vietnam-hero.jpg',
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("RemoteConfig Error: $e");
    }
  }

  String get imageAppbarHome => _remoteConfig.getString(_kImageAppbarHome);

// bool get showPromotion => _remoteConfig.getBool('show_promotion');
}