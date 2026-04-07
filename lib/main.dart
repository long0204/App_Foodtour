import 'dart:async';
import 'package:Foodtour/services/remote_config_service.dart';
import 'package:Foodtour/services/secure_storage_service.dart';
import 'package:Foodtour/core/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/gen/app_l10n.dart';
import 'core/route.dart';
import 'data/model/restaurant.dart';
import 'data/model/review.dart';

void main() async {
  // Run app in error zone to catch all errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();
    
    // Initialize Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Initialize global error handler
    errorHandler.initialize();
    
    // Initialize Hive
    await Hive.initFlutter();
    await RemoteConfigService().init();
    
    // Migrate old tokens from Hive to SecureStorage (one-time)
    await secureStorage.migrateFromHive();
    
    Hive.registerAdapter(ReviewAdapter());
    Hive.registerAdapter(RestaurantAdapter());

    await Hive.openBox<Restaurant>('restaurants');
    await Hive.openBox('userBox');

    runApp(const ProviderScope(child: FoodTourApp()));
  }, (error, stack) {
    // Catch errors from runZonedGuarded
    errorHandler.logError(error, stack, reason: 'Uncaught error in main zone', fatal: true);
  });
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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