import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

// import '../config/constants/firebase_options.dart';

class MyFirebaseCore {
  // MyFirebaseCoreService._();
  // static MyFirebaseCoreService? _i;
  // static MyFirebaseCoreService get instance => _i ??= MyFirebaseCoreService._();

  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  }
}

final firebaseCore = MyFirebaseCore();
