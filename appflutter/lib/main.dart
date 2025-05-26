import 'package:Foodtour/services/auth_service.dart';
import 'package:Foodtour/services/onboarding_loader.dart';
import 'package:Foodtour/services/versionupdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/route.dart';
import 'data/model/favorite_address_model.dart';
import 'data/model/restaurant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await signInAnonymouslyIfNeeded();
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }

  await Hive.initFlutter();
  Hive.registerAdapter(FavoritePlaceAdapter());
  Hive.registerAdapter(RestaurantAdapter());
  await Hive.openBox<FavoritePlace>('favorites');
  await Hive.openBox<Restaurant>('restaurants');
  await Hive.openBox('userBox');

  await authService.init();

  await AppRouter.initRouterLoginStatus();
  final username = authService.getUsername();
  if (username != null) {
    await fetchAndSaveOnboardingData(username);
  }
  appVersion
    ..checkForceUpdate()
    ..checkStoreVersion();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> signInAnonymouslyIfNeeded() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
    debugPrint("✅ Đã đăng nhập ẩn danh");
  } else {
    debugPrint("ℹ️ Đã có user: ${auth.currentUser!.uid}");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Foodtour',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.red[100],
      ),
    );
  }
}
