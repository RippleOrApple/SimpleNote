import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/settings/application/theme_controller.dart';
import 'package:simple_note/features/settings/domain/theme_scheme.dart';

void main() {
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
  });
}
