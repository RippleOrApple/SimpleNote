import 'package:flutter/material.dart';

import '../../features/appearance/domain/rgb_color.dart';
import '../../features/settings/domain/theme_scheme.dart';
import 'derived_surface_palette.dart';

class AppTheme {
  const AppTheme._();

  static const fontFamily = 'NotoSansSC';

  static ThemeData fromScheme(AppThemeScheme scheme) {
    final palette = DerivedSurfacePalette.from(
      accent: RgbColor.fromColor(scheme.primaryColor),
      background: RgbColor.fromColor(scheme.backgroundColor),
      brightness: scheme.brightness,
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: scheme.brightness,
    ).copyWith(
      primary: palette.accent,
      onPrimary: palette.onAccent,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      textTheme: Typography.material2021().black.apply(
            fontFamily: fontFamily,
            bodyColor: palette.onBackground,
            displayColor: palette.onBackground,
          ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.onBackground,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent.withValues(alpha: 0.18),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent.withValues(alpha: 0.18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
      ),
    );
  }
}
