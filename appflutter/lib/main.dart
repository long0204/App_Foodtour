import 'package:Foodtour/root_screen.dart';
import 'package:Foodtour/ui/home/MainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/model/favorite_address_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }

  // Khởi tạo Hive và register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(FavoritePlaceAdapter());
  await Hive.openBox<FavoritePlace>('favorites');

  final prefs = await SharedPreferences.getInstance();
  final hasData = prefs.containsKey('start_date');

  runApp(
    ProviderScope(
      child: MyApp(hasData: hasData),
    ),
  );
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
        scaffoldBackgroundColor: Colors.redAccent[100],
      ),
      home: hasData ? const RandomItemScreen() : const OnboardingScreen(),
    );
  }
}
