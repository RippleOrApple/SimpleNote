import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/theme/app_theme.dart';
import 'package:simple_note/core/theme/derived_surface_palette.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/application/appearance_controller.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/settings/application/theme_controller.dart';
import 'package:simple_note/features/settings/domain/theme_scheme.dart';

void main() {
  test('fresh adapter initialization keeps exact V2 defaults', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    await container.read(themeControllerProvider.future);
    final appearance = await container.read(
      appearanceControllerProvider.future,
    );

    expect(appearance.portable, AppearanceSettings.defaults());
    expect(appearance.customColors, isEmpty);
  });

  test('loads presets saves custom theme and restores active theme', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    final initial = await container.read(themeControllerProvider.future);

    expect(initial.activeTheme.id, AppThemeScheme.minimalLight.id);
    expect(
      initial.savedThemes.map((theme) => theme.id),
      containsAll(AppThemeScheme.presets.map((theme) => theme.id)),
    );

    final controller = container.read(themeControllerProvider.notifier);
    await controller.applyTheme(AppThemeScheme.nightBlack);

    final darkState = await container.read(themeControllerProvider.future);
    expect(darkState.activeTheme.id, AppThemeScheme.nightBlack.id);
    expect(darkState.activeTheme.brightness, Brightness.dark);

    controller.updateDraft(primaryColor: const Color(0xFF2F6F4E));
    await controller.saveCustomTheme(name: 'Focus Green');

    final customState = await container.read(themeControllerProvider.future);
    expect(customState.activeTheme.name, 'Focus Green');
    expect(
      customState.savedThemes.map((theme) => theme.name),
      contains('Focus Green'),
    );

    container.invalidate(themeControllerProvider);
    final reloaded = await container.read(themeControllerProvider.future);
    expect(reloaded.activeTheme.name, 'Focus Green');

    await container
        .read(themeControllerProvider.notifier)
        .restoreDefaultTheme();
    final restored = await container.read(themeControllerProvider.future);
    expect(restored.activeTheme.id, AppThemeScheme.minimalLight.id);

    await container.read(appearanceControllerProvider.future);
    await container
        .read(appearanceControllerProvider.notifier)
        .setAccent(const RgbColor(0x5E9D83));
    final adapted = await container.read(themeControllerProvider.future);
    expect(adapted.activeTheme.primaryColor, const Color(0xFF5E9D83));
  });

  test('preserves an existing active V1 theme while seeding presets', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.themeSchemesDao.upsertTheme(
      const ThemeSchemesCompanion(
        id: Value('legacy-custom'),
        name: Value('Legacy custom'),
        backgroundColor: Value(0xFFF8F8F6),
        primaryColor: Value(0xFF123456),
        textColor: Value(0xFF202124),
        surfaceColor: Value(0xFFFFFFFF),
        brightness: Value('light'),
        createdAt: Value(1),
        updatedAt: Value(1),
        isActive: Value(true),
      ),
    );
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    final state = await container.read(themeControllerProvider.future);

    expect(state.activeTheme.id, 'legacy-custom');
    expect(state.activeTheme.primaryColor, const Color(0xFF123456));
  });

  test('normalizes deprecated text and surface edits before draft and save',
      () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    await container.read(themeControllerProvider.future);
    final controller = container.read(themeControllerProvider.notifier);
    const background = Color(0xFFDFE8F5);
    const primary = Color(0xFF5E9D83);
    final expected = DerivedSurfacePalette.from(
      accent: RgbColor.fromColor(primary),
      background: RgbColor.fromColor(background),
      brightness: Brightness.light,
    );

    controller.updateDraft(
      backgroundColor: background,
      primaryColor: primary,
      textColor: const Color(0xFFFF00FF),
      surfaceColor: const Color(0xFF00FFFF),
      brightness: Brightness.light,
    );

    final draft = container.read(themeControllerProvider).valueOrNull!;
    expect(draft.draftTheme.textColor, expected.onBackground);
    expect(draft.draftTheme.surfaceColor, expected.surface);

    await controller.saveCustomTheme(name: 'Canonical');
    final saved = await database.themeSchemesDao.activeTheme();
    expect(saved!.textColor, expected.onBackground.toARGB32());
    expect(saved.surfaceColor, expected.surface.toARGB32());

    container.invalidate(themeControllerProvider);
    final reloaded = await container.read(themeControllerProvider.future);
    expect(reloaded.activeTheme.textColor, expected.onBackground);
    expect(reloaded.activeTheme.surfaceColor, expected.surface);
  });

  test('dark legacy theme derives rendering without mutating portable color',
      () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    await container.read(themeControllerProvider.future);
    final controller = container.read(themeControllerProvider.notifier);
    const rawBackground = Color(0xFFEEDBD5);
    const rawAccent = Color(0xFFCA806E);
    final expected = DerivedSurfacePalette.from(
      accent: RgbColor.fromColor(rawAccent),
      background: RgbColor.fromColor(rawBackground),
      brightness: Brightness.dark,
    );

    controller.updateDraft(
      backgroundColor: rawBackground,
      primaryColor: rawAccent,
      brightness: Brightness.dark,
    );

    final draft = container.read(themeControllerProvider).valueOrNull!;
    expect(draft.activeTheme.backgroundColor, rawBackground);
    _expectThemeUsesPalette(
      AppTheme.fromScheme(draft.activeTheme),
      expected,
    );

    await controller.saveCustomTheme(name: 'Dark raw input');

    final appearance = await container.read(
      appearanceControllerProvider.future,
    );
    expect(
      appearance.portable.background.color,
      RgbColor.fromColor(rawBackground),
    );
    expect(
      appearance.portable.lastPureBackground,
      RgbColor.fromColor(rawBackground),
    );
    final saved = container.read(themeControllerProvider).valueOrNull!;
    expect(saved.activeTheme.backgroundColor, rawBackground);
    _expectThemeUsesPalette(
      AppTheme.fromScheme(saved.activeTheme),
      expected,
    );
  });
}

void _expectThemeUsesPalette(
  ThemeData theme,
  DerivedSurfacePalette expected,
) {
  expect(theme.scaffoldBackgroundColor, expected.background);
  expect(theme.appBarTheme.backgroundColor, expected.background);
  expect(theme.appBarTheme.foregroundColor, expected.onBackground);
  expect(theme.textTheme.bodyMedium!.color, expected.onBackground);
  expect(theme.colorScheme.primary, expected.accent);
  expect(theme.colorScheme.onPrimary, expected.onAccent);
  expect(theme.colorScheme.surface, expected.surface);
  expect(theme.colorScheme.onSurface, expected.onSurface);
  expect(theme.cardTheme.color, expected.surface);
  expect(theme.floatingActionButtonTheme.backgroundColor, expected.accent);
  expect(theme.floatingActionButtonTheme.foregroundColor, expected.onAccent);
  expect(
    contrastRatio(
      theme.textTheme.bodyMedium!.color!,
      theme.scaffoldBackgroundColor,
    ),
    greaterThanOrEqualTo(4.5),
  );
}
