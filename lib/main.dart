import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/route.dart';
import 'data/model/restaurant.dart';
import 'data/model/review.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(RestaurantAdapter());

  await Hive.openBox<Restaurant>('restaurants');
  await Hive.openBox('userBox');

  runApp(const ProviderScope(child: FoodTourApp()));
}

class FoodTourApp extends StatelessWidget {
  const FoodTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'FoodTour Cộng Đồng',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}