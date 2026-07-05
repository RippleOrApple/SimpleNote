import 'package:flutter/material.dart';

import '../../features/settings/domain/theme_scheme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData fromScheme(AppThemeScheme scheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: scheme.primaryColor,
      primary: scheme.primaryColor,
      surface: scheme.surfaceColor,
      brightness: scheme.brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scheme.backgroundColor,
      textTheme: Typography.material2021().black.apply(
            bodyColor: scheme.textColor,
            displayColor: scheme.textColor,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.backgroundColor,
        foregroundColor: scheme.textColor,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
