import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/derived_surface_palette.dart';
import '../../../database/app_database.dart';
import '../../../core/utils/time.dart';
import '../../appearance/domain/appearance_presets.dart';
import '../../appearance/domain/appearance_settings.dart';
import '../../appearance/domain/rgb_color.dart';
import '../domain/theme_scheme.dart';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return DriftThemeRepository(ref.watch(appDatabaseProvider));
});

abstract class ThemeRepository {
  Future<AppThemeScheme> getActiveTheme();
  Future<List<AppThemeScheme>> getSavedThemes();
  Future<void> saveTheme(AppThemeScheme scheme);
  Future<void> activateTheme(String id);
  AppThemeScheme fromAppearance(
    AppearanceSettings appearance, {
    AppThemeScheme? metadata,
  });
  AppThemeScheme normalizeLegacyTheme(AppThemeScheme scheme);
}

class DriftThemeRepository implements ThemeRepository {
  const DriftThemeRepository(this._database);

  final AppDatabase _database;

  @override
  Future<AppThemeScheme> getActiveTheme() async {
    final row = await _database.themeSchemesDao.activeTheme();
    return row == null ? AppThemeScheme.minimalLight : _fromRow(row);
  }

  @override
  Future<List<AppThemeScheme>> getSavedThemes() async {
    final rows = await _database.themeSchemesDao.savedThemes();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> saveTheme(AppThemeScheme scheme) {
    return _database.themeSchemesDao.upsertTheme(_toCompanion(scheme));
  }

  @override
  Future<void> activateTheme(String id) {
    return _database.themeSchemesDao.activateTheme(id);
  }

  @override
  AppThemeScheme fromAppearance(
    AppearanceSettings appearance, {
    AppThemeScheme? metadata,
  }) {
    final brightness = switch (appearance.brightnessMode) {
      AppBrightnessMode.light => Brightness.light,
      AppBrightnessMode.dark => Brightness.dark,
      AppBrightnessMode.system => metadata?.brightness ?? Brightness.light,
    };
    final background =
        appearance.background.color ?? appearance.lastPureBackground;
    final palette = DerivedSurfacePalette.from(
      accent: appearance.accent,
      background: background,
      brightness: brightness,
    );
    return AppThemeScheme(
      id: metadata?.id ?? 'appearance-v2',
      name: metadata?.name ?? 'Appearance',
      backgroundColor: background.toColor(),
      primaryColor: appearance.accent.toColor(),
      textColor: palette.onBackground,
      surfaceColor: palette.surface,
      brightness: brightness,
      isActive: true,
    );
  }

  @override
  AppThemeScheme normalizeLegacyTheme(AppThemeScheme scheme) {
    final palette = DerivedSurfacePalette.from(
      accent: RgbColor.fromColor(scheme.primaryColor),
      background: RgbColor.fromColor(scheme.backgroundColor),
      brightness: scheme.brightness,
    );
    return scheme.copyWith(
      textColor: palette.onBackground,
      surfaceColor: palette.surface,
    );
  }

  ThemeSchemesCompanion _toCompanion(AppThemeScheme scheme) {
    final now = Clock.nowMillis();
    return ThemeSchemesCompanion(
      id: Value(scheme.id),
      name: Value(scheme.name),
      backgroundColor: Value(scheme.backgroundColor.toARGB32()),
      primaryColor: Value(scheme.primaryColor.toARGB32()),
      textColor: Value(scheme.textColor.toARGB32()),
      surfaceColor: Value(scheme.surfaceColor.toARGB32()),
      brightness: Value(scheme.brightness.name),
      createdAt: Value(now),
      updatedAt: Value(now),
      isActive: Value(scheme.isActive),
    );
  }

  AppThemeScheme _fromRow(ThemeSchemeRow row) {
    return AppThemeScheme(
      id: row.id,
      name: row.name,
      backgroundColor: Color(row.backgroundColor),
      primaryColor: Color(row.primaryColor),
      textColor: Color(row.textColor),
      surfaceColor: Color(row.surfaceColor),
      brightness: row.brightness == Brightness.dark.name
          ? Brightness.dark
          : Brightness.light,
      isActive: row.isActive,
    );
  }
}
