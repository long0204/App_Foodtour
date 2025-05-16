import 'package:Foodtour/root_screen.dart';
import 'package:Foodtour/ui/main/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


  final prefs = await SharedPreferences.getInstance();
  final hasData = prefs.containsKey('start_date');

  runApp(
    ProviderScope(
      child: MyApp(hasData: hasData),
    ),
  );
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
  final bool hasData;

  const MyApp({super.key, required this.hasData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodtour',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.red[50],
      ),
      home: hasData ? const MainScreen() : const OnboardingScreen(),
    );
  }
}
