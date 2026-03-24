import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/model/restaurant.dart';
import '../ui/add_place/add_place_screen.dart';
import '../services/crashlytics.dart';
import '../ui/address/restaurant_detail_screen.dart';
import '../ui/auth/login/login_screen.dart';
import '../ui/auth/provider/auth_notifier.dart';
import '../ui/auth/register/register_screen.dart';
import '../ui/favorite_address/favorite_address.dart';
import '../ui/home/home_screen.dart';
import '../ui/list_address/community_list_screen.dart';
import '../ui/map/food_map_screen.dart';
import '../ui/root/root_screen.dart';
import '../ui/spinWheel/SpinWheelScreen.dart';

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

  static bool _isLoggedIn = false;

  static setIsLoggedIn(bool v) => _isLoggedIn = v;

  static Future<void> initRouterLoginStatus() async {
    final box = await Hive.openBox('userBox');
    final token = box.get('token');
    final loggedIn = token != null && token.toString().isNotEmpty;
    _isLoggedIn = loggedIn;
    authNotifier.setLogin(loggedIn);
  }

  static GoRouter get router => _router;

  static GlobalKey get key => _rootNavigatorKey;

  static NavigatorState? get state => _rootNavigatorKey.currentState;

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static final GoRouter _router = GoRouter(
    initialLocation: rootRoute,
    debugLogDiagnostics: false,
    refreshListenable: authNotifier,
    navigatorKey: _rootNavigatorKey,
    redirect: (_, state) {
      // final goingToLogin = state.uri.toString() == loginRoute;
      // final goingToRegister = state.uri.toString() == registerRoute;
      //
      // if (!_isLoggedIn && !(goingToLogin || goingToRegister)) {
      //   return loginRoute;
      // }
      //
      // if (_isLoggedIn && (goingToLogin || goingToRegister)) {
      //   return rootRoute;
      // }
      //
      // return null;
      //   final goingToLogin = state.uri.toString() == loginRoute;
      //   final goingToRegister = state.uri.toString() == registerRoute;
      //   final goingToModeSelect = state.uri.toString() == modeSelectRoute;
      //
      //   if (!_isLoggedIn && !(goingToLogin || goingToRegister)) {
      //     return loginRoute;
      //   }
      //
      //   if (_isLoggedIn && (goingToLogin || goingToRegister)) {
      //     return rootRoute;
      //   }
      //
      //   final box = Hive.box('userBox');
      //   final selectedMode = box.get('selectedMode');
      //
      //   if (selectedMode == null && !goingToModeSelect) {
      //     return modeSelectRoute;
      //   }
      //   return null;
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
      GoRoute(
        path: registerRoute,
        builder: (_, __) => const RegisterScreen(),
      ),
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
        path: communityListRoute,
        builder: (context, state) {
          final categoryName = state.extra as String? ?? "Danh mục";
          return CommunityListScreen(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: detailRoute,
        builder: (context, state) {
          final restaurant = state.extra as Restaurant;

          return RestaurantDetailScreen(restaurant: restaurant);
        },
      ),
    ],
  );

  static CupertinoPage<dynamic> _cupertinoPage(Widget view) {
    return CupertinoPage(child: view);
  }
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
