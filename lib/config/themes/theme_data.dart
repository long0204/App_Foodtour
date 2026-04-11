import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';
import 'text_style.dart';

ThemeData get lightTheme {
  return ThemeData(
    primaryColor: Colors.black,
    canvasColor: Colors.black54,
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.amber,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
    ),
    fontFamily: FontFamily.k2d,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.teal,
            disabledForegroundColor: Colors.red.withValues(alpha: 0.38),
            side: const BorderSide(),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))))),
    textTheme: ThemeData.light().textTheme.copyWith(
      headlineSmall: k2d600,
      displayMedium: k2d500,
      bodyMedium: k2d500,
      bodyLarge: k2d600,
      titleMedium: k2d500,
      titleSmall: k2d400,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
