import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/application/appearance_controller.dart';
import 'package:simple_note/features/appearance/presentation/appearance_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  testWidgets('shows every Task 6 appearance control with stable keys',
      (tester) async {
    final harness = await _pumpAppearance(tester);
    addTearDown(harness.dispose);

    for (final key in [
      'background-preset-DFE8F5',
      'accent-preset-596790',
      'note-paper-FAFAF7',
      'appearance-color-target',
      'appearance-rgb-field',
      'appearance-save-color-button',
      'appearance-extract-color-button',
      'appearance-background-image-button',
      'appearance-background-sync-switch',
      'appearance-background-focus',
      'appearance-background-zoom-slider',
      'appearance-background-blur-slider',
      'appearance-background-overlay-slider',
      'appearance-tint-slider',
      'appearance-glass-slider',
      'appearance-dark-overlay-slider',
      'appearance-ui-scale',
      'appearance-brightness-mode',
      'appearance-density',
      'appearance-note-size-slider',
      'appearance-note-line-height-slider',
      'appearance-motion-level',
      'appearance-haptics-mode',
    ]) {
      expect(find.byKey(Key(key)), findsOneWidget, reason: key);
    }
    expect(find.textContaining('Navigation'), findsOneWidget);
  });

  testWidgets('malformed RGB and HEX never replace the previous color',
      (tester) async {
    final harness = await _pumpAppearance(tester);
    addTearDown(harness.dispose);
    final before = (await harness.container.read(
      appearanceControllerProvider.future,
    ))
        .portable
        .accent;

    for (final malformed in [
      '#12345',
      '12#3456',
      '+1,2,3',
      '-0,2,3',
      '0x10,2,3',
    ]) {
      await tester.enterText(
        find.byKey(const Key('appearance-rgb-field')),
        malformed,
      );
      await tester.tap(find.byKey(const Key('appearance-save-color-button')));
      await tester.pump();

      final field = tester.widget<TextField>(
        find.byKey(const Key('appearance-rgb-field')),
      );
      expect(field.decoration?.errorText, isNotNull, reason: malformed);
      final after = (await harness.container.read(
        appearanceControllerProvider.future,
      ))
          .portable
          .accent;
      expect(after, before, reason: malformed);
    }
  });

  testWidgets('applies a valid RGB value to the selected target',
      (tester) async {
    final harness = await _pumpAppearance(tester);
    addTearDown(harness.dispose);

    await tester.enterText(
      find.byKey(const Key('appearance-rgb-field')),
      '94,157,131',
    );
    await tester.tap(find.byKey(const Key('appearance-save-color-button')));
    await tester.pump();
    await harness.container.pump();

    final state = await harness.container.read(
      appearanceControllerProvider.future,
    );
    expect(state.portable.accent.value, 0x5E9D83);
  });

  testWidgets('explains that haptics are disabled on Windows', (tester) async {
    final harness = await _pumpAppearance(tester);
    addTearDown(harness.dispose);

    expect(find.textContaining('Android'), findsWidgets);
    final haptics = tester.widget<DropdownButtonFormField>(
      find.byKey(const Key('appearance-haptics-mode')),
    );
    expect(haptics.onChanged, isNull);
  });

  testWidgets('renders the selected wallpaper in the crop preview',
      (tester) async {
    final harness = await _pumpAppearance(tester);
    addTearDown(harness.dispose);

    await tester.tap(
      find.byKey(const Key('background-wallpaper-mist-morning')),
    );
    await tester.pump();
    await harness.container.pump();
    await tester.pump();

    final preview = find.byKey(const Key('appearance-background-preview'));
    expect(preview, findsOneWidget);
    expect(
      find.descendant(of: preview, matching: find.byType(Image)),
      findsOneWidget,
    );
  });
}

Future<_AppearanceHarness> _pumpAppearance(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 2200));
  final database = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      deviceInfoProvider.overrideWithValue(_windowsDevice),
    ],
  );
  await container.read(appearanceControllerProvider.future);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: AppearancePage()),
      ),
    ),
  );
  await tester.pump();

  return _AppearanceHarness(container, database, tester);
}

final class _AppearanceHarness {
  const _AppearanceHarness(this.container, this.database, this.tester);

  final ProviderContainer container;
  final AppDatabase database;
  final WidgetTester tester;

  Future<void> dispose() async {
    container.dispose();
    await database.close();
    await tester.binding.setSurfaceSize(null);
  }
}

const _windowsDevice = DeviceInfo(
  deviceId: 'test-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);
