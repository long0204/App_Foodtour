import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/model/restaurant.dart';
import '../ui/account/widgets/edit_profile_screen.dart';
import '../ui/account/widgets/history_screen.dart';
import '../ui/add_place/add_place_screen.dart';
import '../services/crashlytics.dart';
import '../ui/address/restaurant_detail_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/widgets/email_auth_screen.dart';
import '../ui/favorite_address/favorite_address.dart';
import '../ui/home/home_screen.dart';
import '../ui/map/food_map_screen.dart';
import '../ui/root/root_screen.dart';
import '../ui/spinWheel/SpinWheelScreen.dart';
import '../ui/gamification/leaderboard_screen.dart';
import '../ui/gamification/badges_section.dart';

class ScreenLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    crashlytics.logCurrentScreen(route.settings.name ?? '');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    crashlytics.logCurrentScreen(route.settings.name ?? '');
  }
}

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
  GlobalKey<NavigatorState>();

  static Future<void> initRouterLoginStatus() async {
    final box = await Hive.openBox('userBox');
    // Check token for initialization
    await box.get('token');
  }
  static bool get isUserLoggedIn => FirebaseAuth.instance.currentUser != null;

  static GoRouter get router => _router;

  static GlobalKey get key => _rootNavigatorKey;

  static NavigatorState? get state => _rootNavigatorKey.currentState;

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static final GoRouter _router = GoRouter(
    initialLocation: rootRoute,
    debugLogDiagnostics: false,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final bool loggedIn = isUserLoggedIn;

      final bool isAuthRoute = state.matchedLocation == loginRoute ||
          state.matchedLocation == registerRoute ||
          state.matchedLocation == emailAuthRoute;

      if (!loggedIn && !isAuthRoute) {
        return loginRoute;
      }

      if (loggedIn && isAuthRoute) {
        return rootRoute;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: rootRoute,
        builder: (_, __) => const RootScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (_, __) => const LoginScreen(),
      ),
      // GoRoute(
      //   path: registerRoute,
      //   builder: (_, __) => const RegisterScreen(),
      // ),
      GoRoute(
        path: homeRoute,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: foodMapRoute,
        builder: (_, __) => const FoodMapScreen(),
      ),GoRoute(
        path: addPlaceRoute,
        builder: (_, __) => const AddPlaceScreen(),
      ),
      GoRoute(
        path: favorite,
        builder: (_, __) => const FavoritePlacesScreen(),
      ),
      GoRoute(
        path: spinRoute,
        builder: (_, __) => const SpinWheelScreen(),
      ),
      GoRoute(
        path: emailAuthRoute,
        builder: (_, __) => const EmailAuthScreen(),
      ),
      GoRoute(
        path: editProfileRoute,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: historyRoute,
        builder: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          final uid = user?.uid ?? '';

          return HistoryScreen(uid: uid);
        },
      ),
      GoRoute(
        path: leaderboardRoute,
        builder: (_, __) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: badgesRoute,
        builder: (_, __) => const BadgesScreen(),
      ),
      // GoRoute(
      //   path: communityListRoute,
      //   builder: (context, state) {
      //     final categoryName = state.extra as String? ?? "Danh mục";
      //     return CommunityListScreen(categoryName: categoryName);
      //   },
      // ),
      GoRoute(
        path: detailRoute,
        builder: (context, state) {
          final restaurant = state.extra as Restaurant;

          return RestaurantDetailScreen(restaurant: restaurant);
        },
      ),
    ],
  );
}

void go(String location) => AppRouter.context?.go(location);

void goNamed(String name) => AppRouter.context?.goNamed(name);

Future? push(String location, {Object? extra}) =>
    AppRouter.context?.push(location, extra: extra);

Future? pushNamed(String name) => AppRouter.context?.pushNamed(name);

void pushReplacement(String location, {Object? extra}) =>
    AppRouter.context?.pushReplacement(location, extra: extra);

void pushReplacementNamed(String name) =>
    AppRouter.context?.pushReplacementNamed(name);

void pushNamedAndRemoveUntil(String name) {
  // 1. Pop hết các route
  AppRouter.state?.popUntil((route) => route.isFirst);
  // 2. Thay màn đầu tiên bằng màn mới (login)
  AppRouter.context?.pushReplacementNamed(name);
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

void pop([dynamic result]) => AppRouter.key.currentContext?.pop(result);

void popUtil() => AppRouter.state?.popUntil((route) => route.isFirst);

const defaultRoute = '/';
const loginRoute = '/login';
const registerRoute = '/register';
const rootRoute = '/root';
const spinRoute = '/spin-wheel';
const favorite = '/favorite';
const detailRoute = '/detail';
const homeRoute = '/home';
const addressRoute = '/address';
const createaddressRoute = '/createaddress';
const planRoute = '/plan';
const createplanRoute = '/createplan';
const onboardingRoute = '/dashboard';
const rateRoute = '/rate';
const groupRoute = '/grouphome';
const createGroupRoute = '/creategroup';
const modeSelectRoute = '/mode-select';
const foodMapRoute = '/food-map';
const addPlaceRoute = '/add-place';
const communityListRoute = '/community-list';
const emailAuthRoute = '/email-auth';
const editProfileRoute = '/edit-profile';
const historyRoute = '/history-screen';
const leaderboardRoute = '/leaderboard';
const badgesRoute = '/badges';
