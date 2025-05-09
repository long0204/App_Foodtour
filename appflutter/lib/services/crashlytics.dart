import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_core.dart';

class CrashService {
  static CrashService? _instance;

  CrashService._();

  static CrashService get instance => _instance ??= CrashService._();

  late FirebaseCrashlytics _crashlytics;

  Future<void> _initFirebase() async {
    await firebaseCore.init();
    _crashlytics = FirebaseCrashlytics.instance;
  }

  Future<void> init() async {
    await _initFirebase();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: false);
      return true;
    };
  }

  Future<void> recordError(dynamic error, StackTrace? stack) async {
    await _crashlytics.recordError(Exception(error.toString()), stack);
  }

  void logCurrentScreen(String screenName) {
    FirebaseCrashlytics.instance
        .setCustomKey('last_screen', screenName)
        .catchError((e) {});
  }

  void logCurrentUser(int id) {
    FirebaseCrashlytics.instance.setCustomKey('user_id', id).catchError((e) {});
  }
}

final CrashService crashlytics = CrashService.instance;
