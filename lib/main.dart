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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/gen/app_l10n.dart';
import 'core/api/api_client.dart';
import 'core/route.dart';
import 'data/model/restaurant.dart';
import 'data/model/review.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await dotenv.load(fileName: ".env");
    print("✅ Environment variables loaded");

    await Firebase.initializeApp();

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    errorHandler.initialize();

    await Hive.initFlutter();
    await RemoteConfigService().init();

    await secureStorage.migrateFromHive();

    print("🔧 Initializing API Client...");
    apiClient = ApiClient(secureStorage: secureStorage);
    print("✅ API Client initialized successfully");
    
    Hive.registerAdapter(ReviewAdapter());
    Hive.registerAdapter(RestaurantAdapter());

    await Hive.openBox<Restaurant>('restaurants');
    await Hive.openBox('userBox');

    runApp(const ProviderScope(child: FoodTourApp()));
  }, (error, stack) {
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