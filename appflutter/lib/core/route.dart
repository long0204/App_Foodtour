import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../services/crashlytics.dart';
import '../ui/detail/DetailScreen.dart';
import '../ui/favorite_address/favorite_address.dart';
import '../ui/home/MainScreen.dart';
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

  static GoRouter get router => _router;

  static GlobalKey get key => _rootNavigatorKey;

  static NavigatorState? get state => _rootNavigatorKey.currentState;

  static BuildContext? get context => _rootNavigatorKey.currentContext;
  static bool hasRedirect = false;

  static final GoRouter _router = GoRouter(
    initialLocation: homeRoute,
    debugLogDiagnostics: false,
    navigatorKey: _rootNavigatorKey,
    // observers: [
    //   ScreenLogger(),
    // ],
    redirect: (_, state) {
      if (hasRedirect) return null;
      hasRedirect = true;
      return _isLoggedIn ? null : loginRoute;
    },
    routes: [
      GoRoute(
        path: homeRoute,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: detailRoute,
        builder: (_, __) => const DetailScreen(
          selectedItem: {},
        ),
      ),
      GoRoute(
        path: favorite,
        builder: (_, __) => const FavoritePlacesScreen(),
      ),
      GoRoute(
        path: spinRoute,
        builder: (_, __) => const SpinWheelScreen(),
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

void pop([dynamic result]) => AppRouter.key.currentContext?.pop(result);

void popUtil() => AppRouter.state?.popUntil((route) => route.isFirst);

const defaultRoute = '/';
const loginRoute = '/login';
const spinRoute = '/spin-wheel';
const favorite = '/favorite';
const detailRoute = '/detail';
const homeRoute = '/home';