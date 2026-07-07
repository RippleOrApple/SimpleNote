import 'package:flutter/material.dart';

import '../../features/settings/domain/theme_scheme.dart';

class AppTheme {
  const AppTheme._();

  static const fontFamily = 'NotoSansSC';

  static ThemeData fromScheme(AppThemeScheme scheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: scheme.primaryColor,
      primary: scheme.primaryColor,
      surface: scheme.surfaceColor,
      brightness: scheme.brightness,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scheme.backgroundColor,
      textTheme: Typography.material2021().black.apply(
            fontFamily: fontFamily,
            bodyColor: scheme.textColor,
            displayColor: scheme.textColor,
          ),
      cardTheme: CardThemeData(
        color: scheme.surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.backgroundColor,
        foregroundColor: scheme.textColor,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceColor,
        indicatorColor: scheme.primaryColor.withValues(alpha: 0.18),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceColor,
        indicatorColor: scheme.primaryColor.withValues(alpha: 0.18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
