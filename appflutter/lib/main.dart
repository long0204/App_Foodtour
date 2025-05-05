import 'dart:convert';
import 'dart:math';

import 'package:Foodtour/root_screen.dart';
import 'package:Foodtour/ui/home/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasData = prefs.containsKey('start_date');

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: hasData ? const RandomItemScreen() : const OnboardingScreen(),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomItemScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.redAccent[100],
      ),
    );
  }
}
